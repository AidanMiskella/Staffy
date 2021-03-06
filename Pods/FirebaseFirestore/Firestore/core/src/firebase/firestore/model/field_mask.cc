/*
 * Copyright 2019 Google
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include "Firestore/core/src/firebase/firestore/model/field_mask.h"

#include "Firestore/core/src/firebase/firestore/model/field_value.h"
#include "Firestore/core/src/firebase/firestore/util/hashing.h"

namespace firebase {
namespace firestore {
namespace model {

bool FieldMask::covers(const FieldPath& fieldPath) const {
  for (const FieldPath& fieldMaskPath : fields_) {
    if (fieldMaskPath.IsPrefixOf(fieldPath)) {
      return true;
    }
  }

  return false;
}

ObjectValue FieldMask::ApplyTo(const ObjectValue& data) const {
  ObjectValue filtered = ObjectValue::Empty();
  for (const FieldPath& path : fields_) {
    if (path.empty()) {
      return data;
    } else {
      absl::optional<FieldValue> new_value = data.Get(path);
      if (new_value) {
        filtered = filtered.Set(path, *new_value);
      }
    }
  }
  return filtered;
}

std::string FieldMask::ToString() const {
  // Ideally, one should use a string builder. Since this is only non-critical
  // code for logging and debugging, the logic is kept simple here.
  std::string result("{ ");
  for (const FieldPath& field : fields_) {
    result += field.CanonicalString() + " ";
  }
  return result + "}";
}

size_t FieldMask::Hash() const {
  return util::Hash(fields_);
}

}  // namespace model
}  // namespace firestore
}  // namespace firebase
