# Uniflix

Uniflix is a Ruby on Rails web app for movie recommendations: users browse suggested titles, open a film, and submit ratings.

The UI routes three complementary strategies—collaborative filtering, content-based filtering, and a past-based / knowledge-discovery path.

The work was done for a university Collaborative Systems course, which also treats hybrid recommendation in the curriculum.

![Interface preview reconstructed from the original project structure](docs/uniflix-preview.png)

*Preview reconstructed from layouts, views, and `application.css` ([`docs/uniflix-preview.html`](docs/uniflix-preview.html)); not a live screenshot. Image shows the **upper portion** of the mockup (banner, header, nav, info block).*

## Project context

Academic team submission for **Collaborative Systems** (EIA, UNIRIO): a small Rails prototype built to experiment with **recommender logic**, persistence of suggestion sets, and a simple authenticated browsing flow—not a production product.

## Recommendation approaches

- **Collaborative filtering** — Neighbor-style scoring (Pearson / distance tables in `public/`, logic in `User#get_colab_based`); default home route shows these picks (`movies#collaborative_filtering`).
- **Content-based filtering** — Uses category and vote averages to estimate whether an unseen title fits the user (`User#get_content_based`; `movies#content_based_filtering`).
- **Past-based (“desc. conhecimento”)** — Association-style support / confidence rules over the last highly rated film (`User#get_past_based`; `movies#past_filtering`).

**Hybrid:** Covered in the course; here, “hybrid” means **contrasting those paradigms in one app**, not a dedicated fourth algorithm or merged score.

## Tech stack

Ruby **2.5.0**, Rails **~> 5.2.3**, **PostgreSQL**, **Puma**, **Devise**, **Sass** / **CoffeeScript** / **jQuery** / **Turbolinks** (see `Gemfile`). Front-end styling lives under `app/assets/stylesheets` (notably `application.css`).

## Status

Preserved as **coursework**; **not actively maintained**. Dependencies and Rails are dated; expect security warnings on archived dependencies.
