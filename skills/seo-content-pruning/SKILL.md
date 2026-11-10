---
name: seo-content-pruning
description: Prune and repair low-value pages to lift organic traffic — build a cut list from Search Console, protect pages that have backlinks, give every page one verdict (delete, merge or rewrite), retitle around its top query and group pages into topic hubs. Use when auditing thin or dead content, cleaning up old pages or expired listings, or planning redirects.
version: 1.0.0
---

# SEO content pruning

Publishing more does not fix a site that is carrying dead pages. Find the pages
nobody reaches, decide each one's fate, and repair the ones worth keeping.
Treat traffic claims from case studies as anecdotes, not targets.

Project-specific rules (URL structure, CMS, redirect mechanism) belong in the project's own CLAUDE.md — follow them when present.

## Inputs

| Need | Source |
|---|---|
| Clicks and impressions per page, last 3 months | Search Console: Performance → Pages (export), or a Search Console MCP server if one is connected |
| Queries per page | Search Console: open a page → Queries |
| Backlinks per URL | Any backlink checker the user has (a free checker is enough for a first pass) |
| Publish and last-modified dates | CMS, sitemap or git history |

Ask for the export if no data source is connected. Never invent numbers.

## 1. Build the cut list

Start with pages that had **0 clicks and under 50 impressions in the last 3 months**.
Tune the threshold to the size of the site. Then remove from the list:

- pages published or substantially changed in the last 3 months (not enough data yet);
- pages that convert, or that users need even without search traffic (login, legal, pricing, support, checkout);
- seasonal pages that are simply out of season.

## 2. Protect pages with backlinks

Check every URL on the list for external links. A page with backlinks is never
plainly deleted: it is merged or redirected (301) to the most relevant live
page so the links keep their value.

## 3. One verdict per page

| Verdict | When | What happens |
|---|---|---|
| **Delete** | No readers, no backlinks, topic not worth covering | Return 410 (or 404), remove internal links and the sitemap entry |
| **Merge** | Another page covers the same topic better | Move anything unique into that page, 301 to it |
| **Rewrite** | The topic matters but the page is thin, stale or mistitled | Keep the URL, fix the content and title (step 4) |
| **Keep** | Wrongly listed after the exclusions above | No change |

Never redirect everything to the home page; a redirect must land on a page
that answers the same need.

## 4. Retitle around the top query

For each page being kept or rewritten, find the query with the most
impressions for that page and put it, in plain words, in the `<title>` and the
H1. Drop vanity titles ("My favourite …"). Make the first paragraph answer
that query directly.

## 5. Group into hubs

Sort the surviving pages into a few topics. Give each topic one hub page that
links to every page in the group, and link each page back to its hub. A handful
of strong hubs beats many weak ones.

## Listings and marketplaces (job boards, classifieds, events)

Expired listings are the largest source of dead pages on these sites and need
their own rule, decided once and applied by the system, not by hand:

- When a listing expires, either remove the page (404/410), or keep it as a
  clearly marked "expired" page that links to similar live listings.
- If the page stays, remove its listing structured data or make sure the
  expiry field (for jobs: `validThrough`) is set and in the past.
- Redirect to the closest category page only when the listing had backlinks.
- Near-duplicate location or skill pages with no listings: merge or noindex
  until they have content.

Check the search engine's current guidance for the listing type before
changing behaviour site-wide.

## Output

Deliver a table (CSV or Markdown) the user can approve line by line:

`url, clicks, impressions, backlinks, verdict, redirect_target, top_query, new_title, hub`

## Guardrails

- Do not delete or redirect anything without the user's approval of the list.
- Make changes on a branch, keep a redirect map in the repo, and deploy redirects before removing pages.
- After deploy: resubmit the sitemap, then compare clicks and impressions after 4 to 8 weeks.
- Do not promise a traffic number.
