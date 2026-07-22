# Pasaley Guff — User Stories (Tailored for Vendor App)

This document contains user stories and acceptance criteria tailored for Pasaley Guff — a vendor app where mobile repair vendors communicate, add categories, and post their products.

---

## Persona: Anji — Shop Owner (Vendor)

1. As Anji, I want to create a vendor profile so that customers see my shop details and contact info.
   - Acceptance Criteria:
     - I can enter shop name, address, phone, and profile image.
     - The profile is visible on my public vendor page.
     - Changes persist across app restarts.

2. As Anji, I want to add product categories (e.g., Screen Repair, Accessories) so I can organize my listings.
   - Acceptance Criteria:
     - I can create, rename, and delete categories.
     - Products can be assigned to categories when created.
     - Category changes reflect in the Explore view.

3. As Anji, I want to create product posts with images, price, and description so buyers can view and contact me.
   - Acceptance Criteria:
     - I can add title, description, price, images, and category.
     - Post appears in my feed and in the relevant category.
     - A success confirmation appears after saving a post.

4. As Anji, I want to receive messages from customers so I can discuss repair details and agree on service.
   - Acceptance Criteria:
     - Customers can send messages from a product or vendor page.
     - New messages increment unread count and show notifications.
     - I can reply and see message timestamps and delivery status.

---

## Persona: Rojina — Technician (Vendor Employee)

1. As Rojina, I want to post service offers (e.g., battery replacement) so customers can discover my specialized services.
   - Acceptance Criteria:
     - I can create a service post with title, price, estimated time, and images.
     - Service posts are searchable and shown under relevant categories.

2. As Rojina, I want to edit product/service posts so I can update price or availability.
   - Acceptance Criteria:
     - I can update title, price, images, and mark availability.
     - Edits are reflected immediately in the feed and saved persistently.

3. As Rojina, I want to view incoming customer chats and assign them to myself so I can manage conversations.
   - Acceptance Criteria:
     - Chats show participant name, last message, and unread count.
     - I can mark a chat as assigned to me and filter assigned chats.

4. As Rojina, I want to see basic analytics (views, likes, inquiries) for my posts so I can prioritize high-demand services.
   - Acceptance Criteria:
     - Each post displays view count, like count, and number of chat inquiries.
     - Analytics update in near-real-time when actions occur.

---

## Persona: Subidha — Store Manager (Vendor Admin)

1. As Subidha, I want to approve or reject posts created by employees so I control what appears on the vendor page.
   - Acceptance Criteria:
     - Posts by employees appear in a pending list for review.
     - I can approve, edit, or reject with a reason; status is visible to the creator.

2. As Subidha, I want to manage multiple categories and reorder them so important services appear first.
   - Acceptance Criteria:
     - I can drag/reorder categories and set a default display order.
     - Category order is respected in Explore and vendor pages.

3. As Subidha, I want to broadcast an announcement to my followers so customers know about holiday hours or sales.
   - Acceptance Criteria:
     - I can compose an announcement that appears as a pinned post or notification.
     - Followers receive a push notification (if enabled) and an in-app banner.

4. As Subidha, I want role-based access (admin/employee) to control who can post or edit.
   - Acceptance Criteria:
     - I can assign roles to vendor team members.
     - Permissions are enforced in the UI (e.g., only admins can delete a vendor profile).

---

## Persona: Neehangma — New Vendor (Onboarding)

1. As Neehangma, I want a simple onboarding wizard to set up my vendor profile quickly.
   - Acceptance Criteria:
     - Step-by-step screens collect essential info: shop name, location, categories, payment/contact details.
     - Onboarding can be skipped and resumed later.

2. As Neehangma, I want guided category suggestions based on my services so I can pick relevant categories faster.
   - Acceptance Criteria:
     - The app suggests top categories during onboarding based on selected service keywords.
     - I can accept suggestions or add custom categories.

3. As Neehangma, I want a verification step (phone or ID) to build trust with customers.
   - Acceptance Criteria:
     - I can verify via SMS code or upload ID documents.
     - Verified badge shows on my vendor profile.

4. As Neehangma, I want to publish my first post during onboarding so my store is visible immediately.
   - Acceptance Criteria:
     - Onboarding offers a quick post composer (title, image, category, price).
     - The created post appears on my vendor page and in Explore.

---

## Persona: Aadesh — Customer (Buyer)

1. As Aadesh, I want to browse vendor categories so I can find vendors offering specific repair services.
   - Acceptance Criteria:
     - Categories are shown in Explore and on vendor pages.
     - Tapping a category shows relevant posts and vendors.

2. As Aadesh, I want to message a vendor directly from a product post so I can ask about price and availability.
   - Acceptance Criteria:
     - The product post has a clear 'Message Vendor' action.
     - Messages are delivered and show read/delivery status.

3. As Aadesh, I want to save products or vendors to a favorites list so I can revisit them later.
   - Acceptance Criteria:
     - I can tap Save on posts/vendors; saved items appear in a favorites view.
     - Saved items persist across sessions.

4. As Aadesh, I want to see vendor ratings and verified badges so I can trust reputable vendors.
   - Acceptance Criteria:
     - Vendor profiles display average rating and verification status.
     - Ratings are calculated from completed service feedback.

---

## Persona: Pramila — Community Moderator (Platform)

1. As Pramila, I want to moderate reported vendor posts so platform quality is maintained.
   - Acceptance Criteria:
     - I can view a queue of reported posts with reasons.
     - I can remove or flag posts and notify the vendor with a reason.

2. As Pramila, I want to enforce category taxonomy so categories remain consistent site-wide.
   - Acceptance Criteria:
     - I can merge or rename categories; changes cascade to posts.
     - Deprecated categories map to new categories where applicable.

3. As Pramila, I want to view vendor metrics for policy review so I can detect suspicious activity.
   - Acceptance Criteria:
     - I can see vendor activity history, rapid post creation spikes, and message volume.
     - I can flag accounts for further investigation.

4. As Pramila, I want to send platform-level announcements to vendors (e.g., policy updates).
   - Acceptance Criteria:
     - I can create announcements that appear in vendor dashboards.
     - Vendors receive in-app notices and optional email digests.

---

## Persona: Shrisha — Marketing Vendor (Promotions)

1. As Shrisha, I want to create promotional posts with start/end dates so I can run limited-time offers.
   - Acceptance Criteria:
     - Promotions can be scheduled and expire automatically.
     - Expired promotions are marked and optionally hidden from Explore.

2. As Shrisha, I want boosted posts (paid) so my products get higher visibility in Explore.
   - Acceptance Criteria:
     - I can select a budget and duration for boosting a post.
     - Boosted posts appear in priority placements during the campaign.

3. As Shrisha, I want to target promotions to specific categories or locations so offers reach relevant customers.
   - Acceptance Criteria:
     - Boost configuration allows category and location targeting.
     - Campaign reach estimates are shown before purchase.

4. As Shrisha, I want to view campaign performance (impressions, clicks, messages) so I can optimize promotions.
   - Acceptance Criteria:
     - Campaign dashboard shows impressions, CTR, saves, and message conversions.

---

## Persona: Akrity — Support Agent (Vendor Support)

1. As Akrity, I want to respond to vendor support tickets so I can resolve onboarding or posting issues.
   - Acceptance Criteria:
     - Vendors can create support tickets with category and description.
     - Support agents can comment, change status, and resolve tickets.

2. As Akrity, I want to escalate technical issues to engineering with logs and reproduction steps so problems are fixed faster.
   - Acceptance Criteria:
     - I can attach device logs, screenshots, and steps to escalate.
     - Escalations create linked issues in the internal tracking system (placeholder link).

3. As Akrity, I want canned responses for common queries so I can reply efficiently.
   - Acceptance Criteria:
     - I can insert pre-defined templates into ticket replies.
     - Templates are editable by support leads.

4. As Akrity, I want to view vendor account and verification status on tickets so I can give accurate guidance.
   - Acceptance Criteria:
     - Tickets show vendor profile summary, verification, and recent activity.

---

### Notes
- These stories prioritize vendor-facing capabilities: profile management, categories, posting, messaging, roles, onboarding, and moderation.
- Next steps: format into a CSV or Jira card export if you want to import into a project board.
