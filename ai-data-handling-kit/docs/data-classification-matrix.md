# 🗃️ AI Data Classification Matrix

## Classification Framework

### Data Sensitivity Levels

| Level | Label | Description | AI Use Restrictions | Retention Period |
|-------|-------|-------------|-------------------|------------------|
| **L1** | 🔴 **Restricted** | Personal health data, financial records, biometric data | No AI training, local processing only | As required by law |
| **L2** | 🟡 **Confidential** | Personal identifiers, customer data, proprietary algorithms | Encrypted AI training only, audit trail required | 7 years max |
| **L3** | 🟢 **Internal** | Business communications, operational metrics, employee data | AI training permitted with consent | 3 years max |
| **L4** | 🔵 **Public** | Marketing materials, published research, public statements | Unrestricted AI use | Indefinite |

---

## AI Training Data Classification

### Input Data Assessment

```markdown
Data Source: _________________
Classification Level: [ ] L1 [ ] L2 [ ] L3 [ ] L4

Assessment Criteria:
□ Contains personal identifiers (names, SSN, email)
□ Includes protected health information (PHI)
□ Contains financial account information
□ Includes biometric or genetic data
□ Contains proprietary business information
□ Includes customer communication records
□ Contains employee personal information
□ Includes trade secrets or IP

Geographic Considerations:
□ EU residents (GDPR applies)
□ California residents (CCPA applies)
□ Healthcare context (HIPAA applies)
□ Financial context (SOX/PCI applies)
```

### Output Data Classification

```markdown
AI-Generated Content: _________________
Derived Classification: [ ] L1 [ ] L2 [ ] L3 [ ] L4

Output Assessment:
□ Could reveal personal information through inference
□ Contains synthetic but realistic personal data
□ Includes business-sensitive insights or predictions
□ Could be used to identify individuals
□ Contains financial predictions or recommendations
□ Includes health-related predictions or recommendations
```

---

## Handling Requirements by Classification

### L1 - Restricted Data 🔴

**Storage Requirements:**
- Encrypted at rest (AES-256 minimum)
- Encrypted in transit (TLS 1.3 minimum)
- Air-gapped or dedicated secure environment
- No cloud storage without explicit approval

**Processing Restrictions:**
- No AI model training permitted
- Local processing only with audit logging
- Human oversight required for all operations
- Data minimization strictly enforced

**Access Controls:**
- Role-based access with least privilege
- Multi-factor authentication required
- Access logging and monitoring
- Regular access review and certification

**Retention & Disposal:**
- Retain only as long as legally required
- Secure deletion using NIST SP 800-88 standards
- Certificate of destruction required
- Annual retention review

### L2 - Confidential Data 🟡

**Storage Requirements:**
- Encrypted at rest and in transit
- Approved cloud providers only
- Geographic data residency compliance
- Backup encryption required

**Processing Restrictions:**
- AI training permitted with encryption
- Audit trail required for all AI operations
- Data anonymization preferred
- Consent tracking required

**Access Controls:**
- Role-based access controls
- MFA for privileged access
- Business need justification required
- Quarterly access review

**Retention & Disposal:**
- Maximum 7-year retention
- Automated deletion workflows
- Secure deletion verification
- Annual data inventory

### L3 - Internal Data 🟢

**Storage Requirements:**
- Standard encryption (AES-128 minimum)
- Corporate cloud storage approved
- Regional backup compliance
- Version control for datasets

**Processing Restrictions:**
- AI training permitted with consent
- Usage monitoring recommended
- Data quality validation required
- Model bias testing recommended

**Access Controls:**
- Employee access by default
- Contractor access with approval
- Guest access prohibited
- Semi-annual access review

**Retention & Disposal:**
- Maximum 3-year retention
- Automated archival processes
- Standard deletion procedures
- Bi-annual data cleanup

### L4 - Public Data 🔵

**Storage Requirements:**
- No special encryption required
- Any approved storage platform
- Standard backup procedures
- Public dataset documentation

**Processing Restrictions:**
- Unrestricted AI training and processing
- Usage tracking for resource management
- Quality assurance recommended
- Attribution requirements may apply

**Access Controls:**
- Public access permitted
- Download tracking optional
- No special access controls required
- Annual usage review

---

## Implementation Checklist

### Initial Setup
- [ ] Install data classification tools
- [ ] Configure automated scanning
- [ ] Train staff on classification levels
- [ ] Establish approval workflows
- [ ] Document data lineage mapping

### Ongoing Operations
- [ ] Weekly classification audits
- [ ] Monthly retention review
- [ ] Quarterly access certification
- [ ] Annual policy review
- [ ] Continuous monitoring alerts

### Compliance Verification
- [ ] GDPR data mapping complete
- [ ] HIPAA safeguards documented
- [ ] SOX controls implemented
- [ ] Industry standards aligned
- [ ] Legal review completed

---

## Sector-Specific Adaptations

### Healthcare Clinics
- All patient data starts at L1 (Restricted)
- Research data may be L2 with proper consent
- Operational data typically L3
- Published research results are L4

### Family Offices
- Client financial data is L1 (Restricted)
- Investment research may be L2
- Internal communications are L3
- Public filings and reports are L4

### MSP/SMB Services
- Client data inherits client's classification
- Service delivery data typically L2-L3
- Internal tools and processes are L3
- Marketing and public content is L4

---

**Next Steps:** Configure automated classification tools using `classify.sh` script and implement monitoring dashboard.
