---
name: pre-launch-compliance-check
description: Pre-launch legal, privacy and honest-design checklist for a web or mobile app, with GDPR points for products that hold personal data (consent, data rights, retention, marketing email, dark patterns, false claims, licences, children, AI use of user data). Use before a public launch, before adding sign-up, payments or marketing email, or when asked whether an app is safe or legal to ship. Not legal advice.
version: 1.0.0
---

# Pre-launch compliance check

AI coding tools build the app; they do not tell you what the law expects of it.
Run every check below against the real code and the real screens before launch.

**This is an engineering checklist, not legal advice.** Requirements vary by
country and by the kind of product. Flag what a lawyer must decide; do not
decide it for them.

## How to run it

1. Read the code, config and UI copy. Open the running app where possible.
2. Mark each item `PASS`, `FAIL`, `N/A` or `CANNOT VERIFY`, with evidence (`file:line`, a screenshot, a URL).
3. Do not mark `PASS` from intent or comments; the behaviour must exist.
4. Report `FAIL` and `CANNOT VERIFY` first, with the smallest fix for each.

## Consent and accounts

1. Sign-up has an unticked checkbox (or equivalent clear action) for the terms and the privacy policy, with working links.
2. Marketing consent is a **separate**, unticked checkbox; it is never bundled with the terms.
3. Acceptance is recorded: who, which document version, when.
4. Users under the age of digital consent are blocked or routed through parental consent, if the product can reach them.

## Data rights and retention

5. A user can download their data and delete their account without contacting support.
6. Deletion really deletes (or anonymises) across the database, backups policy, logs, analytics and third parties.
7. A retention limit exists for each kind of personal data, and something enforces it.
8. Only data the product needs is collected; optional fields are optional.

## Marketing and email

9. Every marketing email has a working unsubscribe link, honoured without a login.
10. Transactional and marketing emails are separated, so unsubscribing does not stop receipts or security notices.

## Honest design

11. No dark patterns: cancelling is as easy as signing up; no pre-ticked upsells; no guilt-trip buttons.
12. No fake countdown timers, fake scarcity or fake activity ("3 people are viewing this").
13. No fake reviews or testimonials; real ones are attributable.
14. No unsupported claims ("guaranteed to double your revenue"); every number has a source.
15. No false security or compliance claims ("bank-grade", "GDPR compliant", badges) unless they are true and current.

## Accessibility

16. Everything works by keyboard, with a visible focus state.
17. Images have alt text; form fields have labels; text contrast meets WCAG AA (see the `color-system` skill).

## Licences and intellectual property

18. Images, icons, fonts and copy are licensed for this use; AI-generated assets are checked for look-alikes of real brands.
19. Open-source dependencies' licences are compatible with how the product is distributed; required notices are shipped.
20. If users can upload content, there is a takedown contact and a process for copyright notices.

## AI and third parties

21. User data is not used to train or tune models without explicit permission; provider settings that allow training are off.
22. Personal data is not sent to unvetted or free-tier AI APIs. Every processor is listed and has a data processing agreement.
23. Secrets are not in the client bundle or the repository; third-party scripts are limited to what the product needs.

## If the product has EU users or holds personal data (GDPR)

24. A legal basis is identified for each purpose of processing (consent, contract, legitimate interest, …).
25. The privacy policy names the controller, purposes, legal bases, recipients, retention periods, transfers and user rights.
26. Non-essential cookies and trackers load only after consent; declining is as easy as accepting.
27. Transfers outside the EU/EEA have a valid mechanism, per processor.
28. There is a process, an owner and a deadline for access and deletion requests, and for reporting a personal-data breach.
29. Two-sided products (for example employers and candidates) give each side its own consent text and its own data rules.

## Report

```
Verdict: READY / NOT READY / NEEDS LEGAL REVIEW
FAIL:          <item> — <evidence> — <smallest fix>
CANNOT VERIFY: <item> — <what is missing>
PASS: <count>   N/A: <count>
For the lawyer: <questions only a lawyer can settle>
```

For a full audit against a named framework, hand over to the `compliance-auditor` agent.
