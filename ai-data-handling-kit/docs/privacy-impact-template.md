# 🔍 AI Privacy Impact Assessment (PIA) Template

## Project Information

**Project Name:** ________________________________  
**Assessment Date:** ____________________________  
**Assessor:** ___________________________________  
**Review Date:** _______________________________  
**Classification Level:** [ ] L1 [ ] L2 [ ] L3 [ ] L4  

---

## Section 1: AI System Overview

### 1.1 System Description
**What AI system is being deployed?**
```
Purpose: ________________________________________________
Technology: _____________________________________________
Vendor/Platform: _______________________________________
Implementation Timeline: _______________________________
```

### 1.2 Data Types and Sources
**What personal data will be processed?**

| Data Type | Source | Volume | Sensitivity | Legal Basis |
|-----------|--------|---------|-------------|-------------|
| [ ] Names and identifiers | | | [ ] L1 [ ] L2 [ ] L3 [ ] L4 | |
| [ ] Contact information | | | [ ] L1 [ ] L2 [ ] L3 [ ] L4 | |
| [ ] Financial data | | | [ ] L1 [ ] L2 [ ] L3 [ ] L4 | |
| [ ] Health information | | | [ ] L1 [ ] L2 [ ] L3 [ ] L4 | |
| [ ] Biometric data | | | [ ] L1 [ ] L2 [ ] L3 [ ] L4 | |
| [ ] Behavioral patterns | | | [ ] L1 [ ] L2 [ ] L3 [ ] L4 | |
| [ ] Location data | | | [ ] L1 [ ] L2 [ ] L3 [ ] L4 | |
| [ ] Communications | | | [ ] L1 [ ] L2 [ ] L3 [ ] L4 | |

### 1.3 Data Subjects
**Who is affected by this AI system?**
- [ ] Employees
- [ ] Customers/Clients
- [ ] Patients
- [ ] Vendors/Partners
- [ ] General Public
- [ ] Minors (under 18)
- [ ] Other: ________________

---

## Section 2: Privacy Risk Assessment

### 2.1 Data Collection Risks

**Risk Level:** [ ] Low [ ] Medium [ ] High [ ] Critical

| Risk Factor | Present? | Impact | Mitigation |
|-------------|----------|---------|------------|
| Excessive data collection | [ ] Yes [ ] No | [ ] L [ ] M [ ] H | |
| Unclear consent mechanisms | [ ] Yes [ ] No | [ ] L [ ] M [ ] H | |
| Data collection from minors | [ ] Yes [ ] No | [ ] L [ ] M [ ] H | |
| Sensitive data collection | [ ] Yes [ ] No | [ ] L [ ] M [ ] H | |
| Third-party data sources | [ ] Yes [ ] No | [ ] L [ ] M [ ] H | |

### 2.2 AI Processing Risks

**Risk Level:** [ ] Low [ ] Medium [ ] High [ ] Critical

| Risk Factor | Present? | Impact | Mitigation |
|-------------|----------|---------|------------|
| Algorithmic bias potential | [ ] Yes [ ] No | [ ] L [ ] M [ ] H | |
| Automated decision-making | [ ] Yes [ ] No | [ ] L [ ] M [ ] H | |
| Profiling or scoring | [ ] Yes [ ] No | [ ] L [ ] M [ ] H | |
| Inference of sensitive attributes | [ ] Yes [ ] No | [ ] L [ ] M [ ] H | |
| Model training on personal data | [ ] Yes [ ] No | [ ] L [ ] M [ ] H | |

### 2.3 Data Storage and Security Risks

**Risk Level:** [ ] Low [ ] Medium [ ] High [ ] Critical

| Risk Factor | Present? | Impact | Mitigation |
|-------------|----------|---------|------------|
| Cloud storage of sensitive data | [ ] Yes [ ] No | [ ] L [ ] M [ ] H | |
| Cross-border data transfers | [ ] Yes [ ] No | [ ] L [ ] M [ ] H | |
| Data retention beyond necessity | [ ] Yes [ ] No | [ ] L [ ] M [ ] H | |
| Inadequate access controls | [ ] Yes [ ] No | [ ] L [ ] M [ ] H | |
| Vendor data processing | [ ] Yes [ ] No | [ ] L [ ] M [ ] H | |

### 2.4 Individual Rights Risks

**Risk Level:** [ ] Low [ ] Medium [ ] High [ ] Critical

| Risk Factor | Present? | Impact | Mitigation |
|-------------|----------|---------|------------|
| Limited transparency about AI use | [ ] Yes [ ] No | [ ] L [ ] M [ ] H | |
| Difficult to exercise rights | [ ] Yes [ ] No | [ ] L [ ] M [ ] H | |
| No human review option | [ ] Yes [ ] No | [ ] L [ ] M [ ] H | |
| Unclear data lineage | [ ] Yes [ ] No | [ ] L [ ] M [ ] H | |
| Complex opt-out procedures | [ ] Yes [ ] No | [ ] L [ ] M [ ] H | |

---

## Section 3: Legal and Regulatory Compliance

### 3.1 Applicable Regulations
- [ ] **GDPR** (EU General Data Protection Regulation)
- [ ] **CCPA** (California Consumer Privacy Act)
- [ ] **HIPAA** (Health Insurance Portability and Accountability Act)
- [ ] **SOX** (Sarbanes-Oxley Act)
- [ ] **PCI DSS** (Payment Card Industry Data Security Standard)
- [ ] **FERPA** (Family Educational Rights and Privacy Act)
- [ ] **PIPEDA** (Personal Information Protection and Electronic Documents Act)
- [ ] Other: ________________________________

### 3.2 Legal Basis Assessment (GDPR)
**Primary Legal Basis:**
- [ ] Consent (Article 6(1)(a))
- [ ] Contract (Article 6(1)(b))
- [ ] Legal obligation (Article 6(1)(c))
- [ ] Vital interests (Article 6(1)(d))
- [ ] Public task (Article 6(1)(e))
- [ ] Legitimate interests (Article 6(1)(f))

**Special Category Data Legal Basis (if applicable):**
- [ ] Explicit consent (Article 9(2)(a))
- [ ] Employment law (Article 9(2)(b))
- [ ] Vital interests (Article 9(2)(c))
- [ ] Legitimate activities (Article 9(2)(d))
- [ ] Public domain (Article 9(2)(e))
- [ ] Legal claims (Article 9(2)(f))
- [ ] Substantial public interest (Article 9(2)(g))
- [ ] Health/medicine (Article 9(2)(h))
- [ ] Public health (Article 9(2)(i))
- [ ] Research/statistics (Article 9(2)(j))

### 3.3 Individual Rights Implementation
| Right | Mechanism | Timeline | Responsible Party |
|-------|-----------|----------|-------------------|
| Information/Transparency | | | |
| Access | | | |
| Rectification | | | |
| Erasure | | | |
| Restrict Processing | | | |
| Data Portability | | | |
| Object | | | |
| Automated Decision-Making | | | |

---

## Section 4: Risk Mitigation Measures

### 4.1 Technical Safeguards
- [ ] **Encryption at rest** (AES-256 or equivalent)
- [ ] **Encryption in transit** (TLS 1.3 or equivalent)
- [ ] **Access controls** (Role-based, least privilege)
- [ ] **Audit logging** (All access and modifications)
- [ ] **Data anonymization** (Where technically feasible)
- [ ] **Pseudonymization** (Personal identifiers replaced)
- [ ] **Data minimization** (Only necessary data collected)
- [ ] **Model privacy** (Differential privacy, federated learning)

### 4.2 Organizational Safeguards
- [ ] **Privacy training** for all staff with data access
- [ ] **Data processing agreements** with vendors
- [ ] **Regular privacy audits** and assessments
- [ ] **Incident response procedures** for data breaches
- [ ] **Data retention schedules** and deletion procedures
- [ ] **Privacy by design** principles in development
- [ ] **Ethics review board** for AI decisions
- [ ] **Regular bias testing** and fairness audits

### 4.3 Procedural Safeguards
- [ ] **Consent management** system deployed
- [ ] **Privacy notice** updated and accessible
- [ ] **Data subject request** handling procedures
- [ ] **Third-party assessment** of vendors
- [ ] **Regular compliance monitoring** implemented
- [ ] **Staff background checks** for data access roles
- [ ] **Secure development lifecycle** followed
- [ ] **Change management** process includes privacy review

---

## Section 5: Assessment Summary

### 5.1 Overall Risk Rating
**Composite Risk Level:** [ ] Low [ ] Medium [ ] High [ ] Critical

**Risk Calculation:**
- Data Collection Risk: ______
- AI Processing Risk: _______
- Storage/Security Risk: ____
- Individual Rights Risk: ___

### 5.2 Recommendations

**High Priority Actions (Complete before deployment):**
1. ________________________________________________
2. ________________________________________________
3. ________________________________________________

**Medium Priority Actions (Complete within 30 days):**
1. ________________________________________________
2. ________________________________________________
3. ________________________________________________

**Low Priority Actions (Complete within 90 days):**
1. ________________________________________________
2. ________________________________________________
3. ________________________________________________

### 5.3 Approval Decision
- [ ] **Approved** - Risks adequately mitigated
- [ ] **Approved with conditions** - Complete high priority actions first
- [ ] **Rejected** - Unacceptable risk level
- [ ] **Requires additional review** - Escalate to privacy officer

**Approver:** ________________________________  
**Date:** ___________________________________  
**Review Required By:** ______________________  

---

## Section 6: Sector-Specific Considerations

### Healthcare/Clinical Settings
- [ ] HIPAA compliance verified
- [ ] Patient consent mechanisms established
- [ ] Clinical decision-making transparency ensured
- [ ] Medical professional oversight maintained
- [ ] Research use limitations documented

### Financial Services/Family Offices
- [ ] SOX compliance for financial reporting
- [ ] Client financial data segregation
- [ ] Investment decision audit trails
- [ ] Regulatory reporting capabilities
- [ ] Fiduciary duty considerations

### MSP/Multi-Client Environments
- [ ] Client data segregation verified
- [ ] Per-client privacy policies
- [ ] Service level agreement compliance
- [ ] Client notification procedures
- [ ] Incident reporting to clients

---

**Document Version:** 1.0  
**Last Updated:** [Date]  
**Next Review:** [Date + 12 months]  

*This PIA should be reviewed annually or whenever there are significant changes to the AI system, data processing, or applicable regulations.*
