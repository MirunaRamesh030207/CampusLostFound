<%@ page language="java" contentType="text/html; charset=UTF-8" session="true" %>
<%@ page import="model.Item, dao.ItemDAO" %>
<%
    String idParam = request.getParameter("id");
    Item item = null;
    if (idParam != null) {
        try {
            int itemId = Integer.parseInt(idParam);
            ItemDAO dao = new ItemDAO();
            item = dao.getItemById(itemId);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    if (item == null) {
        response.sendRedirect("searchItem.jsp");
        return;
    }
    boolean isLost     = "lost".equalsIgnoreCase(item.getType());
    boolean isResolved = "resolved".equalsIgnoreCase(item.getStatus());

    // Check if logged-in user is the owner
    boolean isOwner = false;
    if (session != null && session.getAttribute("userId") != null) {
        int loggedUserId = Integer.parseInt(session.getAttribute("userId").toString());
        isOwner = (loggedUserId == item.getUserId());
    }

    String repName    = item.getReporterName()    != null ? item.getReporterName()    : "Unknown";
    String repContact = item.getReporterContact() != null ? item.getReporterContact() : "Not available";
    String repRoll    = item.getReporterRoll()    != null ? item.getReporterRoll()    : "N/A";
    String repInitials = repName.length() >= 2 ? repName.substring(0,2).toUpperCase() : "??";
    String itemName   = item.getItemName() != null ? item.getItemName() : item.getCategory();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Item Details — CampusLostFound</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@300;400;500;600&family=Playfair+Display:wght@700&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing:border-box; margin:0; padding:0; }
        :root {
            --bg:#0b0f1a; --surface:#131929; --border:#1e2d45;
            --accent:#3b82f6; --text:#e2e8f0; --muted:#64748b;
            --danger:#ef4444; --success:#22c55e; --warning:#f59e0b; --radius:12px;
        }
        body { font-family:'DM Sans',sans-serif; background:var(--bg); color:var(--text); min-height:100vh; }

        nav { position:sticky; top:0; z-index:100; background:rgba(11,15,26,.9); backdrop-filter:blur(16px); border-bottom:1px solid var(--border); padding:0 2rem; display:flex; align-items:center; justify-content:space-between; height:64px; }
        .nav-brand { display:flex; align-items:center; gap:.6rem; text-decoration:none; color:var(--text); }
        .nav-brand span { font-weight:600; font-size:1.05rem; }

        .page-wrap { max-width:720px; margin:3rem auto; padding:0 1.5rem 4rem; animation:fadeUp .4s ease both; }

        .back-link { display:inline-flex; align-items:center; gap:.4rem; color:var(--muted); text-decoration:none; font-size:.875rem; margin-bottom:1.5rem; transition:color .2s; }
        .back-link:hover { color:var(--text); }
        .back-link svg { width:16px; height:16px; }

        /* ITEM CARD */
        .item-card { background:var(--surface); border:1px solid var(--border); border-radius:16px; overflow:hidden; margin-bottom:1.25rem; }
        .item-card-header { padding:1.5rem; border-bottom:1px solid var(--border); display:flex; align-items:flex-start; gap:1rem; }
        .item-icon { width:52px; height:52px; border-radius:12px; flex-shrink:0; display:flex; align-items:center; justify-content:center; }
        .item-icon svg { width:24px; height:24px; }
        .item-icon.lost  { background:rgba(239,68,68,.12);  color:var(--danger);  border:1px solid rgba(239,68,68,.2); }
        .item-icon.found { background:rgba(34,197,94,.12);  color:var(--success); border:1px solid rgba(34,197,94,.2); }
        .item-header-text h2 { font-family:'Playfair Display',serif; font-size:1.4rem; margin-bottom:.3rem; }
        .item-header-text p  { color:var(--muted); font-size:.875rem; display:flex; align-items:center; gap:.5rem; flex-wrap:wrap; }
        .badge { font-size:.7rem; font-weight:600; letter-spacing:.07em; text-transform:uppercase; padding:.25rem .65rem; border-radius:6px; }
        .badge-lost     { background:rgba(239,68,68,.15);   color:var(--danger); }
        .badge-found    { background:rgba(34,197,94,.15);   color:var(--success); }
        .badge-resolved { background:rgba(100,116,139,.15); color:var(--muted); }
        .badge-open     { background:rgba(59,130,246,.12);  color:var(--accent); }

        .item-img { width:100%; max-height:300px; object-fit:cover; display:block; }

        .item-details { padding:1.25rem 1.5rem; }
        .detail-row { display:flex; gap:.75rem; margin-bottom:.75rem; font-size:.9rem; }
        .detail-label { color:var(--muted); font-weight:500; min-width:100px; flex-shrink:0; }
        .detail-value { color:var(--text); line-height:1.6; }

        /* RESOLVED BANNER */
        .resolved-banner { background:rgba(34,197,94,.08); border:1px solid rgba(34,197,94,.2); border-radius:10px; padding:1rem 1.25rem; margin-bottom:1.25rem; display:flex; align-items:center; gap:.75rem; color:var(--success); font-weight:500; }
        .resolved-banner svg { width:20px; height:20px; flex-shrink:0; }

        /* CONTACT CARD */
        .contact-card { background:var(--surface); border:1px solid var(--border); border-radius:16px; padding:1.5rem; margin-bottom:1.25rem; }
        .contact-card-title { font-size:.78rem; font-weight:600; letter-spacing:.08em; text-transform:uppercase; color:var(--muted); margin-bottom:1.25rem; display:flex; align-items:center; gap:.5rem; }
        .contact-card-title::after { content:''; flex:1; height:1px; background:var(--border); }
        .reporter-info { display:flex; align-items:center; gap:1rem; margin-bottom:1.25rem; }
        .reporter-avatar { width:52px; height:52px; border-radius:50%; background:rgba(59,130,246,.15); color:var(--accent); display:flex; align-items:center; justify-content:center; font-weight:700; font-size:1.1rem; flex-shrink:0; }
        .reporter-name { font-weight:600; font-size:1rem; margin-bottom:.2rem; }
        .reporter-roll { font-size:.82rem; color:var(--muted); }
        .contact-methods { display:grid; grid-template-columns:1fr 1fr; gap:.75rem; }
        .contact-method { background:var(--bg); border:1px solid var(--border); border-radius:10px; padding:1rem; display:flex; align-items:center; gap:.75rem; }
        .contact-method-icon { width:36px; height:36px; border-radius:8px; display:flex; align-items:center; justify-content:center; flex-shrink:0; }
        .contact-method-icon.phone { background:rgba(34,197,94,.12); color:var(--success); }
        .contact-method-icon.roll  { background:rgba(59,130,246,.12); color:var(--accent); }
        .contact-method-icon svg { width:18px; height:18px; }
        .contact-method-label { font-size:.72rem; color:var(--muted); text-transform:uppercase; letter-spacing:.05em; margin-bottom:.15rem; }
        .contact-method-value { font-weight:600; font-size:.95rem; }

        /* MARK RESOLVED CARD */
        .resolve-card { background:var(--surface); border:1px solid rgba(34,197,94,.2); border-radius:16px; padding:1.5rem; margin-bottom:1.25rem; }
        .resolve-card-title { font-size:.78rem; font-weight:600; letter-spacing:.08em; text-transform:uppercase; color:var(--success); margin-bottom:.75rem; display:flex; align-items:center; gap:.5rem; }
        .resolve-card-title svg { width:14px; height:14px; }
        .resolve-card p { font-size:.875rem; color:var(--muted); margin-bottom:1rem; line-height:1.6; }
        .btn-resolve-big { display:inline-flex; align-items:center; gap:.5rem; padding:.8rem 1.6rem; border-radius:9px; background:var(--success); color:#fff; font-family:'DM Sans',sans-serif; font-size:.9rem; font-weight:600; text-decoration:none; transition:all .2s; border:none; cursor:pointer; }
        .btn-resolve-big:hover { background:#16a34a; transform:translateY(-1px); box-shadow:0 6px 20px rgba(34,197,94,.3); }
        .btn-resolve-big svg { width:16px; height:16px; }

        /* NOTICE */
        .notice { background:rgba(245,158,11,.07); border:1px solid rgba(245,158,11,.2); border-radius:10px; padding:1rem 1.1rem; font-size:.84rem; color:var(--warning); display:flex; align-items:flex-start; gap:.6rem; line-height:1.6; margin-bottom:1.25rem; }
        .notice svg { width:16px; height:16px; flex-shrink:0; margin-top:2px; }

        /* BACK BTN */
        .btn-back { display:inline-flex; align-items:center; gap:.5rem; padding:.75rem 1.5rem; border-radius:9px; background:var(--surface); color:var(--text); border:1px solid var(--border); text-decoration:none; font-size:.9rem; font-weight:500; transition:all .2s; }
        .btn-back:hover { border-color:var(--accent); color:var(--accent); }

        @keyframes fadeUp { from{opacity:0;transform:translateY(16px)} to{opacity:1;transform:translateY(0)} }
    </style>
</head>
<body>

<!-- NAV -->
<nav>
    <a href="index.jsp" class="nav-brand">
        <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="#3b82f6" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/>
        </svg>
        <span>CampusLostFound</span>
    </a>
    <a href="searchItem.jsp" style="color:var(--muted);text-decoration:none;font-size:.875rem;font-weight:500">
        ← Back to Browse
    </a>
</nav>

<div class="page-wrap">

    <a href="searchItem.jsp" class="back-link">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="19" y1="12" x2="5" y2="12"/><polyline points="12 19 5 12 12 5"/></svg>
        Back to all items
    </a>

    <%-- Resolved Banner --%>
    <% if (isResolved) { %>
    <div class="resolved-banner">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>
        This item has been marked as resolved — successfully returned to its owner!
    </div>
    <% } %>

    <!-- ITEM DETAIL CARD -->
    <div class="item-card">
        <div class="item-card-header">
            <div class="item-icon <%= isLost ? "lost" : "found" %>">
                <% if (isLost) { %>
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
                <% } else { %>
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>
                <% } %>
            </div>
            <div class="item-header-text">
                <h2><%= itemName %></h2>
                <p>
                    <%= item.getCategory() %>
                    <span class="badge <%= isLost ? "badge-lost" : "badge-found" %>"><%= isLost ? "Lost" : "Found" %></span>
                    <span class="badge <%= isResolved ? "badge-resolved" : "badge-open" %>"><%= isResolved ? "Resolved" : "Open" %></span>
                </p>
            </div>
        </div>

        <% if (item.getImageName() != null && !item.getImageName().trim().isEmpty()) { %>
            <img src="uploads/<%= item.getImageName() %>" class="item-img" alt="Item photo">
        <% } %>

        <div class="item-details">
            <div class="detail-row">
                <span class="detail-label">Location</span>
                <span class="detail-value"><%= item.getLocation() != null ? item.getLocation() : "-" %></span>
            </div>
            <div class="detail-row">
                <span class="detail-label">Date</span>
                <span class="detail-value"><%= item.getDatePost() != null ? item.getDatePost() : "-" %></span>
            </div>
            <div class="detail-row">
                <span class="detail-label">Description</span>
                <span class="detail-value"><%= item.getDescription() != null ? item.getDescription() : "-" %></span>
            </div>
        </div>
    </div>

    <!-- CONTACT CARD -->
    <div class="contact-card">
        <div class="contact-card-title">Reporter Contact Info</div>
        <div class="reporter-info">
            <div class="reporter-avatar"><%= repInitials %></div>
            <div>
                <div class="reporter-name"><%= repName %></div>
                <div class="reporter-roll">Roll No: <%= repRoll %></div>
            </div>
        </div>
        <div class="contact-methods">
            <div class="contact-method">
                <div class="contact-method-icon phone">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07A19.5 19.5 0 0 1 4.69 12 19.79 19.79 0 0 1 1.61 3.41 2 2 0 0 1 3.6 1.24h3a2 2 0 0 1 2 1.72c.13.96.36 1.9.7 2.81a2 2 0 0 1-.45 2.11L7.91 8.96a16 16 0 0 0 6.13 6.13l1.28-1.28a2 2 0 0 1 2.11-.45c.9.34 1.85.57 2.81.7A2 2 0 0 1 22 16.92z"/>
                    </svg>
                </div>
                <div>
                    <div class="contact-method-label">Phone</div>
                    <div class="contact-method-value"><%= repContact %></div>
                </div>
            </div>
            <div class="contact-method">
                <div class="contact-method-icon roll">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/>
                    </svg>
                </div>
                <div>
                    <div class="contact-method-label">Roll Number</div>
                    <div class="contact-method-value"><%= repRoll %></div>
                </div>
            </div>
        </div>
    </div>

    <%-- MARK AS RESOLVED — show only if owner and not yet resolved --%>
    <% if (isOwner && !isResolved) { %>
    <div class="resolve-card">
        <div class="resolve-card-title">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>
            Mark as Resolved
        </div>
        <p>Has this item been returned to its owner? Mark it as resolved to let others know it's been found and returned successfully.</p>
        <a href="ResolveItemServlet?id=<%= item.getItemId() %>&from=searchItem.jsp"
           class="btn-resolve-big"
           onclick="return confirm('Mark this item as resolved?')">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>
            Mark as Resolved
        </a>
    </div>
    <% } %>

    <!-- NOTICE -->
    <div class="notice">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
        Please contact the reporter directly using the information above.
        Meet in a safe, public location on campus to verify and return the item.
    </div>

    <a href="searchItem.jsp" class="btn-back">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="width:16px;height:16px"><line x1="19" y1="12" x2="5" y2="12"/><polyline points="12 19 5 12 12 5"/></svg>
        Back to Browse
    </a>

</div>
</body>
</html>
