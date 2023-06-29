# The issue

Snyk's IaC testing tool appears to only scan the top-level deployment in an ARM template json file. Nested deployments are not scanned. Working directly with ARM json files has been mostly replaced by working in Bicep modules. These modules allow for convenient nesting of files, which helps against code-reuse and allows for nicer organisation of the code. This means that the resulting ARM jsons will generally have nested deployments.

However, there are [first-party repositories offered by Azure containing bicep modules](https://github.com/Azure/ResourceModules), helping to further reduce code-reuse and saving on boilerplate. While we can compile the referenced bicep files into a single ARM json to be scanned by snyk, that doesn't work if snyk only scans the top-level deployment. 

While in this MWE scanning all involved bicep (compiled into ARM) separately would be feasibly, this isn't really an option when using external bicep modules.

# Reproduction steps

1. Build ARM jsons

```
az bicep build -f main.bicep
az bicep build -f submodule.bicep
```

2. Run scan

```
snyk iac test .
```

Output:

```
Snyk Infrastructure as Code

✔ Test completed.

Issues

Low Severity Issues: 1

  [Low] Key Vault accidental purge prevention disabled
  Info:    Key Vault accidental purge prevention disabled. Accidentally purged
           key material will not recoverable
  Rule:    https://security.snyk.io/rules/cloud/SNYK-CC-TF-175
  Path:    resources[0] > properties > enablePurgeProtection
  File:    submodule.json
  Resolve: Set `properties.enablePurgeProtection` attribute to `true`

Medium Severity Issues: 1

  [Medium] Key Vault purge protection is disabled
  Info:    Key Vault purge protection is disabled. Accidentally purged vaults
           and vault items are not recoverable and might lead to data loss
  Rule:    https://security.snyk.io/rules/cloud/SNYK-CC-AZURE-624
  Path:    resources[0] > properties > enablePurgeProtection
  File:    submodule.json
  Resolve: Set `properties.enablePurgeProtection` to `true`

-------------------------------------------------------

Test Summary

  Organization: online-services-independer
  Project name: SnykMWE

✔ Files without issues: 1
✗ Files with issues: 1
  Ignored issues: 0
  Total issues: 2 [ 0 critical, 0 high, 1 medium, 1 low ]

-------------------------------------------------------

Tip

  New: Share your test results in the Snyk Web UI with the option --report
```

Vulnerabilites were only found in submodule.json, not in main.json while the same vulnerabilities were present in that file as well.