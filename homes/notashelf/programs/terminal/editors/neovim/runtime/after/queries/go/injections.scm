; extends

; inject sql into any const string with word query in the name
; e.g. const query = `SELECT * FROM users WHERE name = 'John'`;
(const_spec
  name: (identifier) @_name (#match? @_name "[Qq]uery")
  value: (expression_list
    (raw_string_literal) @injection.content)
    (#offset! @injection.content 0 1 0 -1)
    (#set! injection.language "sql"))

; inject sql in single line strings
(call_expression
  (selector_expression
    field: (field_identifier) @_field (#any-of? @_field "GetContext" "Get" "ExecContext" "Exec" "SelectContext" "Select" "In" "Rebind"))
  (argument_list
    (raw_string_literal) @injection.content)
    (#offset! @injection.content 0 1 0 -1)
    (#set! injection.language "sql")
  )

; inject sql in multi line strings
(call_expression
  (selector_expression
    field: (field_identifier) @_field (#any-of? @_field "GetContext" "Get" "ExecContext" "Exec" "SelectContext" "Select" "In" "Rebind"))
  (argument_list
    (interpreted_string_literal) @injection.content)
    (#offset! @injection.content 0 1 0 -1)
    (#set! injection.language "sql")
  )
