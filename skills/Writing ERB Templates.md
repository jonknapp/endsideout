# HERB-compatible ERB Rules

# Use Rails tag helpers for dynamic attributes
HERB (HTML-aware ERB) disallows <%= %> in any attribute position — names, values, or bare boolean attributes. The fix is always to use tag.* helpers, which handle dynamic values natively.

## Examples

Boolean attributes (checked, open, disabled, etc.)
```erb
<%# bad %>
<input <%= "checked" if condition %>>
<details <%= "open" if condition %>>

<%# good %>
<%= tag.input checked: condition %>
<%= tag.details open: condition do %>...<% end %>
```
Rails emits the attribute when truthy, omits it when falsy.

```erb
Conditional attribute values (style, class, etc.)
<%# bad %>
<div <%= "style='display:none'" unless condition %>>

<%# good %>
<%= tag.div style: ("display:none" unless condition) do %>...<% end %>
Passing nil to a tag helper attribute omits it entirely.
```
```erb
Interpolated href / src
<%# bad %>
<a href="<%= some_helper(value) %>">

<%# good %>
<%= tag.a "text", href: some_helper(value) %>
<%# or %>
<%= link_to "text", some_helper(value) %>
```
General rule: any time an attribute's name or value is dynamic, move the element to a tag.* helper and pass all attributes as keyword arguments. Static inner HTML can still use plain ERB inside the block.