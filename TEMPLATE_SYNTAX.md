# Cookiecutter Template Syntax Notes

## Mixing Jinja2 with Other Template Syntaxes

### The Problem

Cookiecutter uses Jinja2 templating, which processes `{{ }}` and `{% %}` syntax. When your generated files also use template syntax (GitHub Actions, terraform-docs, etc.), you need to escape them.

### Common Conflicts

| Tool | Syntax | Conflict with Cookiecutter? |
|------|--------|----------------------------|
| **GitHub Actions** | `${{ expression }}` | ✅ Yes - Jinja2 tries to process `{{ }}` |
| **terraform-docs** | `{{ .Variable }}` | ✅ Yes - Uses Go templates |
| **Helm** | `{{ .Values.name }}` | ✅ Yes - Uses Go templates |
| **Ansible** | `{{ variable }}` | ✅ Yes - Uses Jinja2 |

### The Solution: `{% raw %}` Tags

Wrap non-Cookiecutter template syntax in `{% raw %}{% endraw %}` tags:

```yaml
# Cookiecutter variable - will be replaced
repo_name: {{cookiecutter.repo_name}}

# GitHub Actions expression - will be preserved
environment: {% raw %}${{ inputs.environment }}{% endraw %}

# terraform-docs Go template - will be preserved
content: {% raw %}{{ .Header }}{% endraw %}
```

### After Cookiecutter Processes

```yaml
# Result after cookiecutter generates the file:
repo_name: my-awesome-repo
environment: ${{ inputs.environment }}
content: {{ .Header }}
```

## IDE Warnings (Expected and Safe to Ignore)

**You will see YAML syntax errors in your IDE** like:
```
✘ Plain value cannot start with directive indicator character %
  {% raw %}${{ inputs.environment }}{% endraw %}
  ^
```

**This is expected!** These files are **Jinja2 templates**, not valid YAML until cookiecutter processes them.

The workflow:
1. **Before**: Template files with `{% raw %}` tags (invalid YAML, but valid Jinja2)
2. **Cookiecutter processes**: Replaces variables, removes `{% raw %}` tags
3. **After**: Valid YAML/HCL/etc files

### How to Handle IDE Warnings

**Option 1: Ignore them** (Recommended)
- The warnings are in template files only
- Generated files will be valid
- CI/CD tests validate the final output

**Option 2: Disable YAML validation for template directories**
```json
// .vscode/settings.json
{
  "yaml.validate": false,
  "yaml.schemas": {
    "https://json.schemastore.org/github-workflow": []
  }
}
```

**Option 3: Use `.yamlignore`** (if your editor supports it)
```
# .yamlignore
**/{{cookiecutter.*}}/**
```

## Examples by File Type

### GitHub Actions Workflows

```yaml
name: {{cookiecutter.workflow_name}}

on:
  workflow_dispatch:
    inputs:
      environment:
        type: string
        required: true

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      # Cookiecutter variable
      - name: Checkout {{cookiecutter.repo_name}}
        uses: actions/checkout@v4

      # GitHub Actions expression (wrapped)
      - name: Deploy to {% raw %}${{ inputs.environment }}{% endraw %}
        run: |
          echo "Deploying to {% raw %}${{ inputs.environment }}{% endraw %}"
```

### terraform-docs Configuration

```yaml
# .terraform-docs.yml
formatter: markdown

content: |-
  {% raw %}{{ .Header }}{% endraw %}

  ## Requirements
  {% raw %}{{ .Requirements }}{% endraw %}

  ## Providers
  {% raw %}{{ .Providers }}{% endraw %}

output:
  template: |-
    <!-- BEGIN_TF_DOCS -->
    {% raw %}{{ .Content }}{% endraw %}
    <!-- END_TF_DOCS -->
```

### Makefile with Variables

```makefile
# Cookiecutter variable
STACK := {{cookiecutter.stack_name}}

# Shell variable (needs escaping)
ENV := {% raw %}$(shell echo $$ENVIRONMENT){% endraw %}

plan:
	tofu -chdir=infra/stacks/$(STACK) plan
```

### Complex Conditionals

When you need conditional logic with both Cookiecutter and target syntax:

**Bad (causes errors):**
```yaml
# This will fail - Jinja2 tries to parse the GitHub Actions expression
value: ${{ inputs.env == 'prod' && '{{cookiecutter.prod_value}}' || '{{cookiecutter.dev_value}}' }}
```

**Good (use raw tags):**
```yaml
# Wrap GitHub Actions parts, leave Cookiecutter parts unwrapped
value: {% raw %}${{ inputs.env == 'prod' && {% endraw %}'{{cookiecutter.prod_value}}'{% raw %} || {% endraw %}'{{cookiecutter.dev_value}}'{% raw %} }}{% endraw %}
```

**Even better (simplify if possible):**
```yaml
# Use Jinja2 conditionals if you know the values at generation time
{% if cookiecutter.environment == 'prod' %}
value: {{cookiecutter.prod_value}}
{% else %}
value: {{cookiecutter.dev_value}}
{% endif %}
```

## Testing Templates

Always test template generation:

```bash
# Generate from template
cookiecutter opentofu --no-input repo_name=test-repo

# Verify generated files are valid
cd test-repo
yamllint .github/workflows/*.yml  # Should pass now
tofu fmt -check
tofu validate
```

## Quick Reference

| Scenario | Syntax |
|----------|--------|
| Cookiecutter variable | `{{cookiecutter.variable}}` |
| GitHub Actions expression | `{% raw %}${{ expression }}{% endraw %}` |
| Go template (terraform-docs, Helm) | `{% raw %}{{ .Variable }}{% endraw %}` |
| Shell variable in Makefile | `{% raw %}$(VAR){% endraw %}` or `{% raw %}$$VAR{% endraw %}` |
| Entire section is non-Jinja2 | `{% raw %}entire content here{% endraw %}` |

## Common Errors and Fixes

### Error: `TemplateSyntaxError: unexpected char '&'`

**Cause**: GitHub Actions `&&` operator in unescaped `${{ }}`

**Fix**: Wrap in `{% raw %}{% endraw %}`

### Error: `TemplateSyntaxError: unexpected '.'`

**Cause**: Go template syntax like `{{ .Variable }}`

**Fix**: Wrap in `{% raw %}{% endraw %}`

### Error: `TemplateSyntaxError: expected token 'end of print statement'`

**Cause**: Complex expression with mixed syntax

**Fix**: Break into parts, wrap each `${{ }}` section separately

## Best Practices

1. ✅ **Wrap early** - Add `{% raw %}` tags as you create templates
2. ✅ **Test often** - Run cookiecutter generation frequently
3. ✅ **Keep it simple** - Avoid deeply nested mixed templates
4. ✅ **Document** - Comment which parts are which syntax
5. ✅ **Validate** - Test generated files with their respective tools
6. ❌ **Don't ignore test failures** - If cookiecutter fails, fix the template
7. ❌ **Don't manually edit generated files** - Always fix the template

## Resources

- [Cookiecutter Documentation](https://cookiecutter.readthedocs.io/)
- [Jinja2 Documentation](https://jinja.palletsprojects.com/)
- [GitHub Actions Expression Syntax](https://docs.github.com/en/actions/learn-github-actions/expressions)
- [terraform-docs Configuration](https://terraform-docs.io/user-guide/configuration/)
