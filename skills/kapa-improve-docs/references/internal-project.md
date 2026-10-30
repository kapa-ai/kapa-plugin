# Internal project results

An internal project indexes what a team says among itself and to customers:
support tickets, an internal wiki, Slack, call notes, shared drives. It is the
best source for "is this supported, and how", and the worst source to copy from.

## Searching it

- Every search is a real query on the internal project: it counts toward its
  quota and appears in its analytics. Ask before the first one.
- Search with the user's question as asked, and with a plainer rephrasing.
- Pass `source_ids_include` with the internal sources only. Many internal
  projects also crawl the public docs, which would answer with the very pages
  you are checking.
- Weigh dates. A support reply from last year may have been reversed since;
  read the whole ticket or thread before trusting one chunk, and prefer the
  newest statement.
- Results carry no source type. Infer it from the URL: a ticketing tool, a
  Slack link, a wiki.

## What may leave it

Only a statement that would be fine in the public docs: what the product does,
does not do, and how to use it. Write that statement in your own words.

## What never leaves it

- Quotes, even short ones.
- Names of customers, people, staff or companies, and anything that identifies
  them: emails, ids, ticket numbers, account details.
- Deals, prices offered, roadmap promises, internal reasoning about capacity or
  risk, security reports, and internal code, repository or class names.
- Anything that looks deliberately undocumented, such as a parameter only some
  customers were given. Flag it for a human; do not document it.

Slack results may look pseudonymised while names remain in the message text.
Treat every result as raw confidential material.

## In a pull request

List the items informed by the internal project and say so in the description,
so a human checks them before merge.
