// Copied from IE Core (hl7-ie/ie-core @ 2b91509, input/fsh/identifiers/NamingSystems.fsh) and renamed for
// IE Medication Events (ADR-001). Only the definitions this IG needs are kept.

Instance: ie-mpd-ns-ihi
InstanceOf: NamingSystem
Usage: #definition
Title: "Individual Health Identifier (IHI)"
* name = "IEMpdNamingSystemIHI"
* status = #draft
* kind = #identifier
* date = "2026-09-24"
* responsible = "HSE"
* description = "PLACEHOLDER URI, pending a URI published by the issuing authority (Requires Clarification, IE Core OI-003). HIQA EP/PS 1.3.1. Issued by the HSE; 18 or 10 digits."
* jurisdiction = urn:iso:std:iso:3166#IE "Ireland"
* uniqueId[0].type = #uri
* uniqueId[=].value = "https://hl7-ie.github.io/ie-core/fhir/ie/core/sid/ihi"
* uniqueId[=].preferred = true


Instance: ie-mpd-ns-ppsn
InstanceOf: NamingSystem
Usage: #definition
Title: "Personal Public Service Number (PPSN)"
* name = "IEMpdNamingSystemPPSN"
* status = #draft
* kind = #identifier
* date = "2026-09-24"
* responsible = "Department of Social Protection"
* description = "PLACEHOLDER URI, pending a URI published by the issuing authority (Requires Clarification, IE Core OI-003). HIQA EP/PS 1.3.2. Use as a health identifier is Requires Clarification (IE Core OI-008)."
* jurisdiction = urn:iso:std:iso:3166#IE "Ireland"
* uniqueId[0].type = #uri
* uniqueId[=].value = "https://hl7-ie.github.io/ie-core/fhir/ie/core/sid/pps"
* uniqueId[=].preferred = true


Instance: ie-mpd-ns-gms
InstanceOf: NamingSystem
Usage: #definition
Title: "PCRS medical card (GMS) number"
* name = "IEMpdNamingSystemGMSMedicalCard"
* status = #draft
* kind = #identifier
* date = "2026-09-24"
* responsible = "HSE PCRS"
* description = "PLACEHOLDER URI, pending a URI published by the issuing authority (Requires Clarification, IE Core OI-003). HIQA EP/PS 1.3.3.1 lists it as an example of an other identifier. HIQA gives no format, so none is enforced (IE Core ADR-006)."
* jurisdiction = urn:iso:std:iso:3166#IE "Ireland"
* uniqueId[0].type = #uri
* uniqueId[=].value = "https://hl7-ie.github.io/ie-core/fhir/ie/core/sid/gms"
* uniqueId[=].preferred = true


Instance: ie-mpd-ns-dps
InstanceOf: NamingSystem
Usage: #definition
Title: "PCRS Drugs Payment Scheme (DPS) number"
* name = "IEMpdNamingSystemDrugsPaymentScheme"
* status = #draft
* kind = #identifier
* date = "2026-09-24"
* responsible = "HSE PCRS"
* description = "PLACEHOLDER URI, pending a URI published by the issuing authority (Requires Clarification, IE Core OI-003). HIQA EP/PS 1.3.3.1 example. No format enforced."
* jurisdiction = urn:iso:std:iso:3166#IE "Ireland"
* uniqueId[0].type = #uri
* uniqueId[=].value = "https://hl7-ie.github.io/ie-core/fhir/ie/core/sid/dps"
* uniqueId[=].preferred = true


Instance: ie-mpd-ns-lti
InstanceOf: NamingSystem
Usage: #definition
Title: "PCRS Long-Term Illness (LTI) scheme number"
* name = "IEMpdNamingSystemLongTermIllness"
* status = #draft
* kind = #identifier
* date = "2026-09-24"
* responsible = "HSE PCRS"
* description = "PLACEHOLDER URI, pending a URI published by the issuing authority (Requires Clarification, IE Core OI-003). HIQA EP/PS 1.3.3.1 example. No format enforced."
* jurisdiction = urn:iso:std:iso:3166#IE "Ireland"
* uniqueId[0].type = #uri
* uniqueId[=].value = "https://hl7-ie.github.io/ie-core/fhir/ie/core/sid/lti"
* uniqueId[=].preferred = true


Instance: ie-mpd-ns-haa
InstanceOf: NamingSystem
Usage: #definition
Title: "PCRS Health (Amendment) Act (HAA) card number"
* name = "IEMpdNamingSystemHealthAmendmentAct"
* status = #draft
* kind = #identifier
* date = "2026-09-24"
* responsible = "HSE PCRS"
* description = "PLACEHOLDER URI, pending a URI published by the issuing authority (Requires Clarification, IE Core OI-003). HIQA EP/PS 1.3.3.1 example (Health Amendment Act card scheme). No format enforced."
* jurisdiction = urn:iso:std:iso:3166#IE "Ireland"
* uniqueId[0].type = #uri
* uniqueId[=].value = "https://hl7-ie.github.io/ie-core/fhir/ie/core/sid/haa"
* uniqueId[=].preferred = true


Instance: ie-mpd-ns-neps
InstanceOf: NamingSystem
Usage: #definition
Title: "National ePrescribing Service (NePS) prescription (group) identifier"
* name = "IEMpdNamingSystemNePSPrescription"
* status = #draft
* kind = #identifier
* date = "2026-09-24"
* responsible = "HSE"
* description = "PLACEHOLDER URI, pending a URI published by the issuing authority (Requires Clarification, IE Core OI-003). HIQA EP 3.1: the NePS electronic prescription (group) identifier used throughout the prescription and dispensation life cycle."
* jurisdiction = urn:iso:std:iso:3166#IE "Ireland"
* uniqueId[0].type = #uri
* uniqueId[=].value = "https://hl7-ie.github.io/ie-core/fhir/ie/core/sid/neps"
* uniqueId[=].preferred = true


Instance: ie-mpd-ns-imc
InstanceOf: NamingSystem
Usage: #definition
Title: "Irish Medical Council registration number (MCRN)"
* name = "IEMpdNamingSystemIMC"
* status = #draft
* kind = #identifier
* date = "2026-09-24"
* responsible = "Medical Council"
* description = "PLACEHOLDER URI, pending a URI published by the issuing authority (Requires Clarification, IE Core OI-003). HIQA EP/PS 2.6.2."
* jurisdiction = urn:iso:std:iso:3166#IE "Ireland"
* uniqueId[0].type = #uri
* uniqueId[=].value = "https://hl7-ie.github.io/ie-core/fhir/ie/core/sid/imc"
* uniqueId[=].preferred = true


Instance: ie-mpd-ns-psi
InstanceOf: NamingSystem
Usage: #definition
Title: "Pharmaceutical Society of Ireland registration number"
* name = "IEMpdNamingSystemPSI"
* status = #draft
* kind = #identifier
* date = "2026-09-24"
* responsible = "Pharmaceutical Society of Ireland"
* description = "PLACEHOLDER URI, pending a URI published by the issuing authority (Requires Clarification, IE Core OI-003). HIQA EP/PS 2.6.2: up to eight digits."
* jurisdiction = urn:iso:std:iso:3166#IE "Ireland"
* uniqueId[0].type = #uri
* uniqueId[=].value = "https://hl7-ie.github.io/ie-core/fhir/ie/core/sid/psi"
* uniqueId[=].preferred = true


Instance: ie-mpd-ns-nmbi
InstanceOf: NamingSystem
Usage: #definition
Title: "Nursing and Midwifery Board of Ireland registration number"
* name = "IEMpdNamingSystemNMBI"
* status = #draft
* kind = #identifier
* date = "2026-09-24"
* responsible = "Nursing and Midwifery Board of Ireland"
* description = "PLACEHOLDER URI, pending a URI published by the issuing authority (Requires Clarification, IE Core OI-003). HIQA EP/PS 2.6.2 (RNP/RMP divisions)."
* jurisdiction = urn:iso:std:iso:3166#IE "Ireland"
* uniqueId[0].type = #uri
* uniqueId[=].value = "https://hl7-ie.github.io/ie-core/fhir/ie/core/sid/nmbi"
* uniqueId[=].preferred = true


Instance: ie-mpd-ns-dental-council
InstanceOf: NamingSystem
Usage: #definition
Title: "Dental Council of Ireland registration number"
* name = "IEMpdNamingSystemDentalCouncil"
* status = #draft
* kind = #identifier
* date = "2026-09-24"
* responsible = "Dental Council of Ireland"
* description = "PLACEHOLDER URI, pending a URI published by the issuing authority (Requires Clarification, IE Core OI-003). HIQA EP definitions (dentist prescribers)."
* jurisdiction = urn:iso:std:iso:3166#IE "Ireland"
* uniqueId[0].type = #uri
* uniqueId[=].value = "https://hl7-ie.github.io/ie-core/fhir/ie/core/sid/dental-council"
* uniqueId[=].preferred = true


Instance: ie-mpd-ns-psi-rpb
InstanceOf: NamingSystem
Usage: #definition
Title: "PSI Retail Pharmacy Business registration number"
* name = "IEMpdNamingSystemPSIRPB"
* status = #draft
* kind = #identifier
* date = "2026-09-24"
* responsible = "Pharmaceutical Society of Ireland"
* description = "PLACEHOLDER URI, pending a URI published by the issuing authority (Requires Clarification, IE Core OI-003). HIQA EP/PS 2.8."
* jurisdiction = urn:iso:std:iso:3166#IE "Ireland"
* uniqueId[0].type = #uri
* uniqueId[=].value = "https://hl7-ie.github.io/ie-core/fhir/ie/core/sid/psi-rpb"
* uniqueId[=].preferred = true


Instance: ie-mpd-ns-gms-panel
InstanceOf: NamingSystem
Usage: #definition
Title: "GMS Panel ID"
* name = "IEMpdNamingSystemGMSPanel"
* status = #draft
* kind = #identifier
* date = "2026-09-24"
* responsible = "HSE PCRS"
* description = "PLACEHOLDER URI, pending a URI published by the issuing authority (Requires Clarification, IE Core OI-003). HIQA EP/PS 2.12."
* jurisdiction = urn:iso:std:iso:3166#IE "Ireland"
* uniqueId[0].type = #uri
* uniqueId[=].value = "https://hl7-ie.github.io/ie-core/fhir/ie/core/sid/gms-panel"
* uniqueId[=].preferred = true

Instance: ie-mpd-ns-hsp-i
InstanceOf: NamingSystem
Usage: #definition
Title: "Health Services Provider Identifier: individual (HSP-I)"
* name = "IEMpdNamingSystemHSPI"
* status = #draft
* kind = #identifier
* date = "2026-09-28"
* responsible = "Minister for Health (functions delegable to the HSE, Health Identifiers Act 2014 s.26)"
* description = "PLACEHOLDER URI in IE Core's namespace (ADR-001), pending a URI published by the issuing authority (IE Core OI-003). The health services provider identifier (HSPI) of an individual provider: Health Identifiers Act 2014 s.13 (assignment, 'a unique number', alphanumeric) and s.14 (National Register of Health Services Provider Identifiers, Parts A health practitioners, C relevant employees, D individual relevant agents). No format is set by the Act, so none is enforced. Whether individual and organisation HSPIs share one number range is Requires Clarification (OI-030)."
* jurisdiction = urn:iso:std:iso:3166#IE "Ireland"
* uniqueId[0].type = #uri
* uniqueId[=].value = "https://hl7-ie.github.io/ie-core/fhir/ie/core/sid/hsp-i"
* uniqueId[=].preferred = true

Instance: ie-mpd-ns-hsp-o
InstanceOf: NamingSystem
Usage: #definition
Title: "Health Services Provider Identifier: organisation (HSP-O)"
* name = "IEMpdNamingSystemHSPO"
* status = #draft
* kind = #identifier
* date = "2026-09-28"
* responsible = "Minister for Health (functions delegable to the HSE, Health Identifiers Act 2014 s.26)"
* description = "PLACEHOLDER URI in IE Core's namespace (ADR-001), pending a URI published by the issuing authority (IE Core OI-003). The health services provider identifier (HSPI) of an organisation provider, such as a hospital, GP practice or pharmacy: Health Identifiers Act 2014 s.13 (assignment, 'a unique number', alphanumeric) and s.14 (National Register of Health Services Provider Identifiers, Parts B relevant bodies, E corporate relevant agents). No format is set by the Act, so none is enforced. Whether individual and organisation HSPIs share one number range is Requires Clarification (OI-030)."
* jurisdiction = urn:iso:std:iso:3166#IE "Ireland"
* uniqueId[0].type = #uri
* uniqueId[=].value = "https://hl7-ie.github.io/ie-core/fhir/ie/core/sid/hsp-o"
* uniqueId[=].preferred = true
