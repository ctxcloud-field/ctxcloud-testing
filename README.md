# ctxcloud-testing

A collection of field-driven test tools, helpers, and simulations to support Cortex Cloud onboarding, validation, and lab automation.

This repo is intended for use by Solutions Architects, Domain Consultants, and Field Engineers working with Palo Alto Networks Cortex Cloud. These tools are not officially supported by Palo Alto Networks but are useful for internal testing, validation, and demonstrations.

---

## 📁 Contents

### `dspm-data-generator/`
Scripts to generate fake, format-valid or masked sensitive data for DSPM scanning:

| File                     | Description                                 |
|--------------------------|---------------------------------------------|
| `dspm-data-generator.sh` | Main generator script                       |
| `dspm-upload-to-s3.sh`   | Optional uploader to Amazon S3              |
| `README.md`              | Detailed usage and examples for the above   |

Use it to test your scanning logic against:

- Credit cards, SSNs, names, emails
- PHI, secrets, developer tokens
- Obfuscated vs realistic data

---

## 🧪 Upcoming Tests

### 🔑 IAM Escalation Simulator

Test scenarios include:
- Creating a new IAM user
- Assigning increasingly privileged roles
- Generating access keys
- Simulating common CIEM misconfigurations

### ☸️ Kubernetes CDR Attack Scenarios

Based on MicroK8s and community-sourced YAMLs, we’ll deploy:
- A malicious privileged container executing attack chains
- An XMRig cryptominer as a DaemonSet
- A persistence mechanism via CronJob

These tests follow Cortex XSIAM/Cloud CDR research and highlight:
- Privileged access
- Persistence techniques
- Suspicious DNS, command, and system behavior

---

## 🙋‍♂️ Author & Support

Created and maintained by [@adilio](https://github.com/adilio) and the Cortex Field team.

> These tools are **not officially affiliated with or supported by Palo Alto Networks**, and are provided **as-is, without warranty**.

---

## 📄 License

Licensed under the [MIT License](./LICENSE).