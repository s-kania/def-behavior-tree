# Behavior Tree Library – Technical Review

## 1. Documentation gaps

1. **RNG range customization** – The README states that the draw-range used by `RandomWithChances` can be customised together with the RNG function. In code the range is hard-coded to `1 .. 100` (see `node_types/random_with_chances.lua`), so the promised feature is missing.
2. **Root node guidelines** – The docs don't mention best practices for choosing the root (e.g. wrapping the tree in `RepeatUntilFailDecorator`) or what happens when the root fails/succeeds.
3. **Persistence example** – Although `activeNode.id` is exposed, there is no end-to-end example that shows how to save & restore a tree between game sessions.
4. **Debug window usage** – README references a debug window using ImGui, but doesn't describe how to enable it or add the dependency.
5. **Error handling** – There is no section explaining how the library reacts when a template is malformed (missing `type`, unknown node name etc.) and how to troubleshoot such errors.

## 2. Opportunities for code improvement

1. **Replace recursion with iteration** – `Sequence.success` and `Selector.fail` recurse to process subsequent children. For deeply nested or long running trees this may overflow the Lua stack. Converting these paths to `while`/`repeat` loops would be safer.
2. **Guard empty composites** – `Composite.start` assumes at least one child (`nodes[1]`). Add an assert and a clear error message when a composite has an empty `nodes` list.
3. **Chance normalisation & validation** – Provide helper that normalises or validates that chances in `RandomWithChances` sum to the expected total, and raise an error otherwise.
4. **Reduce status-propagation boilerplate** – Many decorators duplicate the pattern of forwarding status up the tree. Extract this into shared helper(s) to reduce repetition.
5. **Expose pause / resume** – A simple `pause()` / `resume()` API would let games span tree execution across frames without rebuilding the tree manually.
6. **Stronger template validation** – Detect duplicate tree names, missing fields, or circular references early with descriptive error messages.

## 3. Potential bugs

| # | Description | File / Lines |
|---|-------------|--------------|
| 1 | `RandomWithChances.start` always draws between `1` and `100` which contradicts the claim that the range can be customised. If a custom RNG returns values outside this range, some branches become unreachable. | `node_types/random_with_chances.lua` L8-14 |
| 2 | `Composite.start` blindly accesses `nodes[1]`; a composite registered with an empty list will cause `attempt to index a nil value` at runtime instead of a clear error. | `node_types/composite.lua` L15-17 |
| 3 | `Sequence.success` (and similarly `Selector.fail`) uses recursion to process the next node. Repeating this over long sequences (or within `RepeatUntilFailDecorator`) can exhaust the Lua stack and crash the game. | `node_types/sequence.lua` L6-18 / `selector.lua` L12-22 |

---

*Prepared by: Automated code review bot*