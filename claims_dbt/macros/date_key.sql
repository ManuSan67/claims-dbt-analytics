{% macro date_key(column) -%}
    cast(date_format({{ column }}, 'yyyyMMdd') as int)
{%- endmacro %}
