
# DSPM Test Data Generator

A robust Bash script for generating synthetic, format-valid or masked data for DSPM (Data Security Posture Management) testing. Cross-platform, clean console output, and easy to use in enterprise or lab environments.

---

## 🚀 Features

* Multiple Profiles: Financial, PCI, PII, PHI, Secrets, Mixed
* Format-valid Data (default): Generates realistic (Luhn-valid, regex-valid) credit cards, SSNs, emails, keys, etc.
* Masked Data Option: Use `--masked` for obviously fake (asterisk/partial) values.
* Combined or Split Output: Defaults to one CSV. Use `--split-files` for separate files.
* Interactive Menu: Use `-i` or `--interactive` for easy, guided setup.
* Cross-Platform: Linux, macOS (BSD), and WSL supported.
* ShellCheck-clean and DRY code
* Detailed generation summary with pattern counts

---

## ⚡ Quickstart

Generate all profiles, format-valid data, single CSV (default):

```bash
./dspm-data-generator.sh
```

Masked data (obfuscated):

```bash
./dspm-data-generator.sh --masked
```

Separate file per profile:

```bash
./dspm-data-generator.sh --split-files
```

Interactive menu for all options:

```bash
./dspm-data-generator.sh --interactive
```

Specify record count and profiles:

```bash
./dspm-data-generator.sh --num-records 500 --type financial,phi
```

---

## 📋 Options

| Option              | Description                         | Default          |
| ------------------- | ----------------------------------- | ---------------- |
| `--num-records N`   | Records per profile                 | 1000             |
| `--output-dir DIR`  | Output directory                    | dspm_test_data   |
| `--type LIST`       | Comma-separated profiles to include | all              |
| `--realistic`       | Format-valid data (default)         | true             |
| `--masked`          | Masked/obfuscated data              | false            |
| `--split-files`     | Split CSV per profile               | false            |
| `--interactive, -i` | Show interactive menu               | false            |
| `--help, -h`        | Show help                           | -                |

---

## 🛡️ Data Types

| Profile     | Description                          |
| ----------- | ------------------------------------ |
| `financial` | Banking/finance info (CC, IBAN, etc) |
| `pci`       | PCI DSS data (Cardholder, CVV, etc)  |
| `pii`       | PII (Name, Email, SSN, etc)          |
| `phi`       | PHI (HIPAA) Medical/Lab data         |
| `secrets`   | Developer/API keys, tokens           |
| `mixed`     | Combined data from all profiles      |

---

## 🖥️ Console Output Example

```bash
========== DSPM TEST DATA GENERATION SUMMARY ==========
Generated on: Fri 18 Jul 2025 23:33:38 PDT
DATA PROFILES GENERATED:
PHI                         100 records
Secrets                     100 records
Financial                   100 records
PCI                         100 records
PII                         100 records
Mixed                       100 records

SENSITIVE PATTERNS GENERATED:
Credit Card Numbers              300
IBAN Numbers                     200
SSNs                             200
Internal IPs                     100
API Keys                          16
Medical Records                  100

OUTPUT LOCATION:
Directory: /path/to/dspm_test_data

============= GENERATED FILES SUMMARY =================
Filename                        Size      Records
financial_data.csv               16K          100
mixed_sensitive_data.csv         20K          100
pci_data.csv                     12K          100
phi_data.csv                     16K          100
pii_data.csv                     16K          100
secrets_data.csv                 16K          100

===============================================
  WARNING: This is synthetic test data only!
  Do not use with real sensitive information!
=================================================
```

---

## 📂 Files in This Directory

| File                     | Description                                 |
|--------------------------|---------------------------------------------|
| `dspm-data-generator.sh` | Main generator script                       |
| `dspm-upload-to-s3.sh`   | Optional uploader to Amazon S3              |
| `README.md`              | This documentation file                     |

---

## 🧩 Customization & Extending

* All generators are simple Bash functions—easy to add new fields/profiles
* Modify existing field patterns in the `generate_*` functions
* Add new profiles by creating new generator functions
* CLI flags and logic are at the top of the script for easy editing

---

## 🙋‍♂️ Author & Support

Part of the `ctxcloud-testing` repository. These scripts were created and maintained by [@adilio](https://github.com/adilio) and the Cortex Field team.

> These tools are **not officially affiliated with or supported by Palo Alto Networks**, and are provided **as-is, without warranty**.

---

## 📄 License

Licensed under the [MIT License](./LICENSE).
ing

Contributions are welcome!

* Open [issues](https://github.com/ctxcloud-field/ctxcloud-testing/issues) or submit [pull requests](https://github.com/ctxcloud-field/ctxcloud-testing/pulls)
* If you’re a **Palo Alto Networks** colleague, feel free to reach out to **Adil L internally** if you’d like to collaborate
