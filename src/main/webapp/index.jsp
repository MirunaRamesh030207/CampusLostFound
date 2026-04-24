<%@ page language="java" contentType="text/html; charset=UTF-8" session="true" %>
<%@ page import="java.util.List, model.Item, dao.ItemDAO" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Campus Lost &amp; Found</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@300;400;500;600&family=Playfair+Display:wght@700&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        :root {
            --bg:      #0b0f1a;
            --surface: #131929;
            --border:  #1e2d45;
            --accent:  #3b82f6;
            --accent2: #06b6d4;
            --text:    #e2e8f0;
            --muted:   #64748b;
            --danger:  #ef4444;
            --success: #22c55e;
            --warning: #f59e0b;
            --radius:  12px;
        }
        body { font-family: 'DM Sans', sans-serif; background: var(--bg); color: var(--text); min-height: 100vh; overflow-x: hidden; }

        /* NAV */
        nav { position: sticky; top: 0; z-index: 100; background: rgba(11,15,26,.85); backdrop-filter: blur(16px); border-bottom: 1px solid var(--border); padding: 0 2rem; display: flex; align-items: center; justify-content: space-between; height: 64px; }
        .nav-brand { display: flex; align-items: center; gap: .6rem; text-decoration: none; color: var(--text); }
        .nav-brand svg { color: var(--accent); flex-shrink: 0; }
        .nav-brand span { font-weight: 600; font-size: 1.05rem; letter-spacing: -.3px; }
        .nav-links { display: flex; align-items: center; gap: .25rem; list-style: none; }
        .nav-links a { display: flex; align-items: center; gap: .4rem; padding: .45rem .85rem; border-radius: 8px; text-decoration: none; color: var(--muted); font-size: .875rem; font-weight: 500; transition: color .2s, background .2s; }
        .nav-links a:hover { color: var(--text); background: var(--surface); }
        .nav-links a.active { color: var(--accent); background: rgba(59,130,246,.1); }
        .nav-links a svg { width: 15px; height: 15px; }
        .nav-cta { background: var(--accent) !important; color: white !important; border-radius: 8px; }
        .nav-cta:hover { background: #2563eb !important; }
        .nav-user { color: var(--success); font-size: .875rem; font-weight: 500; padding: .45rem .85rem; }
        .nav-logout { color: var(--danger) !important; }
        .nav-logout:hover { background: rgba(239,68,68,.08) !important; }

        /* HERO */
        .hero { position: relative; padding: 7rem 2rem 5rem; text-align: center; overflow: hidden; }
        .hero::before { content: ''; position: absolute; inset: 0; background: radial-gradient(ellipse 70% 50% at 50% 0%, rgba(59,130,246,.15) 0%, transparent 70%); pointer-events: none; }
        .hero-badge { display: inline-flex; align-items: center; gap: .4rem; background: rgba(59,130,246,.1); border: 1px solid rgba(59,130,246,.3); color: var(--accent); font-size: .8rem; font-weight: 500; padding: .3rem .8rem; border-radius: 100px; margin-bottom: 1.5rem; animation: fadeDown .6s ease both; }
        .hero h1 { font-family: 'Playfair Display', serif; font-size: clamp(2.4rem, 6vw, 4rem); line-height: 1.15; letter-spacing: -.5px; margin-bottom: 1.2rem; animation: fadeDown .6s .1s ease both; }
        .hero h1 span { background: linear-gradient(135deg, var(--accent), var(--accent2)); -webkit-background-clip: text; -webkit-text-fill-color: transparent; }
        .hero p { max-width: 520px; margin: 0 auto 2.5rem; color: var(--muted); font-size: 1.05rem; line-height: 1.7; animation: fadeDown .6s .2s ease both; }
        .hero-actions { display: flex; gap: 1rem; justify-content: center; flex-wrap: wrap; animation: fadeDown .6s .3s ease both; }

        /* BUTTONS */
        .btn { display: inline-flex; align-items: center; gap: .5rem; padding: .7rem 1.4rem; border-radius: 9px; font-family: 'DM Sans', sans-serif; font-size: .9rem; font-weight: 500; text-decoration: none; border: none; cursor: pointer; transition: all .2s; }
        .btn svg { width: 16px; height: 16px; flex-shrink: 0; }
        .btn-primary { background: var(--accent); color: #fff; }
        .btn-primary:hover { background: #2563eb; transform: translateY(-1px); box-shadow: 0 6px 20px rgba(59,130,246,.35); }
        .btn-secondary { background: var(--surface); color: var(--text); border: 1px solid var(--border); }
        .btn-secondary:hover { border-color: var(--accent); color: var(--accent); transform: translateY(-1px); }
        .btn-outline { background: transparent; color: var(--text); border: 1px solid var(--border); }
        .btn-outline:hover { background: var(--surface); border-color: var(--muted); }
        .btn-sm { padding: .4rem .9rem; font-size: .8rem; border-radius: 7px; }

        /* STATS */
        .stats { display: grid; grid-template-columns: repeat(4, 1fr); gap: 1px; background: var(--border); border-top: 1px solid var(--border); border-bottom: 1px solid var(--border); }
        .stat-card { background: var(--surface); padding: 2rem 1.5rem; text-align: center; transition: background .2s; }
        .stat-card:hover { background: #162035; }
        .stat-number { font-family: 'Playfair Display', serif; font-size: 2.4rem; font-weight: 700; line-height: 1; margin-bottom: .4rem; }
        .stat-number.blue  { color: var(--accent); }
        .stat-number.green { color: var(--success); }
        .stat-number.amber { color: var(--warning); }
        .stat-number.red   { color: var(--danger); }
        .stat-label { font-size: .72rem; letter-spacing: .12em; text-transform: uppercase; color: var(--muted); font-weight: 500; }

        /* SECTION */
        .section { padding: 3.5rem 2rem; max-width: 1100px; margin: 0 auto; }
        .section-header { display: flex; align-items: center; justify-content: space-between; margin-bottom: 1.75rem; }
        .section-title { font-size: 1.2rem; font-weight: 600; display: flex; align-items: center; gap: .5rem; }
        .section-title svg { color: var(--accent); }

        /* ITEM CARDS */
        .items-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); gap: 1rem; }
        .item-card { background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius); padding: 1.25rem; transition: border-color .2s, transform .2s, box-shadow .2s; }
        .item-card:hover { border-color: rgba(59,130,246,.4); transform: translateY(-2px); box-shadow: 0 8px 30px rgba(0,0,0,.3); }
        .card-top { display: flex; align-items: flex-start; justify-content: space-between; margin-bottom: 1rem; }
        .card-icon { width: 42px; height: 42px; border-radius: 10px; display: flex; align-items: center; justify-content: center; flex-shrink: 0; }
        .card-icon.lost-icon  { background: rgba(239,68,68,.12); color: var(--danger); }
        .card-icon.found-icon { background: rgba(34,197,94,.12);  color: var(--success); }
        .card-icon svg { width: 20px; height: 20px; }
        .badge { font-size: .7rem; font-weight: 600; letter-spacing: .06em; text-transform: uppercase; padding: .25rem .6rem; border-radius: 6px; }
        .badge-lost  { background: rgba(239,68,68,.15); color: var(--danger); }
        .badge-found { background: rgba(34,197,94,.15); color: var(--success); }
        .card-title { font-weight: 600; font-size: 1rem; margin-bottom: .3rem; }
        .card-meta { display: flex; align-items: center; gap: .3rem; font-size: .8rem; color: var(--muted); margin-bottom: .6rem; }
        .card-meta svg { width: 12px; height: 12px; }
        .card-desc { font-size: .85rem; color: #94a3b8; line-height: 1.55; margin-bottom: 1rem; }
        .card-img { width: 100%; height: 140px; object-fit: cover; border-radius: 8px; margin-bottom: .75rem; display: block; }
        .card-footer { display: flex; align-items: center; justify-content: space-between; }
        .card-user { display: flex; align-items: center; gap: .5rem; font-size: .82rem; }
        .avatar { width: 28px; height: 28px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: .7rem; font-weight: 700; flex-shrink: 0; }
        .av-blue  { background: rgba(59,130,246,.2); color: var(--accent); }
        .av-green { background: rgba(34,197,94,.2);  color: var(--success); }

        /* EMPTY STATE */
        .empty-state { grid-column: 1 / -1; text-align: center; padding: 4rem 2rem; color: var(--muted); }
        .empty-state svg { opacity: .3; margin-bottom: 1rem; }
        .empty-state p { font-size: .95rem; margin-bottom: 1.25rem; }

        /* HOW IT WORKS */
        .how-section { padding: 4rem 2rem; background: var(--surface); border-top: 1px solid var(--border); }
        .how-inner { max-width: 900px; margin: 0 auto; text-align: center; }
        .how-inner h2 { font-family: 'Playfair Display', serif; font-size: 1.8rem; margin-bottom: .75rem; }
        .how-inner > p { color: var(--muted); margin-bottom: 2.5rem; }
        .steps { display: grid; grid-template-columns: repeat(3,1fr); gap: 1.5rem; text-align: left; }
        .step { background: var(--bg); border: 1px solid var(--border); border-radius: var(--radius); padding: 1.5rem; position: relative; overflow: hidden; }
        .step::before { content: attr(data-n); position: absolute; right: 1rem; top: .75rem; font-family: 'Playfair Display', serif; font-size: 4rem; font-weight: 700; color: rgba(255,255,255,.03); line-height: 1; }
        .step-icon { width: 44px; height: 44px; border-radius: 10px; background: rgba(59,130,246,.1); display: flex; align-items: center; justify-content: center; color: var(--accent); margin-bottom: 1rem; }
        .step-icon svg { width: 20px; height: 20px; }
        .step h3 { font-size: .95rem; font-weight: 600; margin-bottom: .4rem; }
        .step p  { font-size: .83rem; color: var(--muted); line-height: 1.6; }

        /* FOOTER */
        footer { border-top: 1px solid var(--border); padding: 2rem; text-align: center; font-size: .8rem; color: var(--muted); }

        /* ANIMATIONS */
        @keyframes fadeDown { from { opacity: 0; transform: translateY(-12px); } to { opacity: 1; transform: translateY(0); } }

        /* RESPONSIVE */
        @media (max-width: 768px) { .stats { grid-template-columns: repeat(2,1fr); } .steps { grid-template-columns: 1fr; } .nav-links { display: none; } }
        @media (max-width: 480px) { .stats { grid-template-columns: 1fr 1fr; } }
    </style>
</head>
<body>

<%
    ItemDAO itemDAO   = new ItemDAO();
    List<Item> allItems = itemDAO.getAllItems();
    int totalReports  = allItems.size();
    int totalResolved = 0;
    int totalLost     = 0;
    int totalFound    = 0;
    for (Item it : allItems) {
        if ("resolved".equalsIgnoreCase(it.getStatus())) totalResolved++;
        if ("lost".equalsIgnoreCase(it.getType()))       totalLost++;
        if ("found".equalsIgnoreCase(it.getType()))      totalFound++;
    }
%>

<!-- NAV -->
<nav>
    <a href="index.jsp" class="nav-brand">
        <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/>
        </svg>
        <span>CampusLostFound</span>
    </a>
    <ul class="nav-links">
   
        <li><a href="index.jsp" class="active">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/><polyline points="9 22 9 12 15 12 15 22"/></svg>
            Home
        </a></li>
         <li><a href="Myreports.jsp"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/><polyline points="9 22 9 12 15 12 15 22"/></svg>
            My Reports </a></li>
        
        <% if (session != null && session.getAttribute("loggedUser") != null) { %>
            <li><span class="nav-user">Hi, <%= session.getAttribute("userName") %> &#128075;</span></li>
            <li><a href="LogoutServlet" class="nav-logout">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg>
                Logout
            </a></li>
        <% } else { %>
            <li><a href="login.jsp">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M15 3h4a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-4"/><polyline points="10 17 15 12 10 7"/><line x1="15" y1="12" x2="3" y2="12"/></svg>
                Login
            </a></li>
            <li><a href="register.jsp" class="nav-cta btn">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
                Register
            </a></li>
        <% } %>
    </ul>
</nav>

<!-- HERO -->
<section class="hero">
    <div class="hero-badge">
        <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>
        Trusted by Students Across Campus
    </div>
    <h1>Recover What <span>Matters</span></h1>
    <p>A dedicated portal for reporting and reclaiming lost belongings across all campus buildings, hostels, and common areas.</p>
    <div class="hero-actions">
        <a href="postItem.jsp" class="btn btn-primary">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="16"/><line x1="8" y1="12" x2="16" y2="12"/></svg>
            Report Lost Item
        </a>
        <a href="postItem.jsp?type=found" class="btn btn-secondary">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/></svg>
            I Found Something
        </a>
        <a href="searchItem.jsp" class="btn btn-outline">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
            Browse All Reports
        </a>
    </div>
</section>

<!-- STATS — Live from DB -->
<div class="stats">
    <div class="stat-card">
        <div class="stat-number blue"><%= totalReports %></div>
        <div class="stat-label">Total Reports</div>
    </div>
    <div class="stat-card">
        <div class="stat-number green"><%= totalResolved %></div>
        <div class="stat-label">Items Returned</div>
    </div>
    <div class="stat-card">
        <div class="stat-number amber"><%= totalLost %></div>
        <div class="stat-label">Pending Lost</div>
    </div>
    <div class="stat-card">
        <div class="stat-number red"><%= totalFound %></div>
        <div class="stat-label">Unclaimed Found</div>
    </div>
</div>

<!-- RECENT REPORTS — Live from DB -->
<div class="section">
    <div class="section-header">
        <div class="section-title">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
            Recent Reports
        </div>
        <a href="searchItem.jsp" class="btn btn-outline btn-sm">View All</a>
    </div>

    <div class="items-grid">
    <%
        if (allItems == null || allItems.isEmpty()) {
    %>
        <div class="empty-state">
            <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
            <p>No reports yet. Be the first to post!</p>
            <a href="postItem.jsp" class="btn btn-primary">Report an Item</a>
        </div>
    <%
        } else {
            int count = 0;
            for (Item item : allItems) {
                if (count >= 3) break;
                count++;
                boolean isLost    = "lost".equalsIgnoreCase(item.getType());
                String badgeClass = isLost ? "badge-lost"    : "badge-found";
                String iconClass  = isLost ? "lost-icon"     : "found-icon";
                String badgeText  = isLost ? "Lost"          : "Found";
                String btnText    = isLost ? "Contact"       : "Claim";
                String btnClass   = isLost ? "btn-secondary" : "btn-primary";
                String statusText = "resolved".equalsIgnoreCase(item.getStatus()) ? "Resolved" : "Open";
                String desc       = (item.getDescription() != null) ? item.getDescription() : "Item";
                String shortDesc  = desc.length() > 100 ? desc.substring(0, 100) + "..." : desc;
                String initials   = desc.length() >= 2 ? desc.substring(0, 2).toUpperCase() : "??";
                String category   = (item.getCategory() != null) ? item.getCategory() : "Item";
                String location   = (item.getLocation()  != null) ? item.getLocation()  : "Campus";
                String datePost   = (item.getDatePost()  != null) ? item.getDatePost()  : "";
    %>
        <div class="item-card">
            <div class="card-top">
                <div class="card-icon <%= iconClass %>">
                    <% if (isLost) { %>
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
                    <% } else { %>
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>
                    <% } %>
                </div>
                <span class="badge <%= badgeClass %>"><%= badgeText %></span>
            </div>
            <div class="card-title"><%= category %></div>
            <div class="card-meta">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/></svg>
                <%= location %> &mdash; <%= datePost %>
            </div>
            <div class="card-desc"><%= shortDesc %></div>
            <% if (item.getImageName() != null && !item.getImageName().trim().isEmpty()) { %>
                <img src="uploads/<%= item.getImageName() %>" class="card-img" alt="Item photo">
            <% } %>
            <div class="card-footer">
                <div class="card-user">
                    <div class="avatar av-blue"><%= initials %></div>
                    <span style="color:var(--muted)"><%= statusText %></span>
                </div>
                <%-- NEW --%>
<a href="contactItem.jsp?id=<%= item.getItemId() %>"
   class="btn <%= btnClass %> btn-sm"><%= btnText %></a>            </div>
        </div>
    <%
            }
        }
    %>
    </div>
</div>

<!-- HOW IT WORKS -->
<div class="how-section">
    <div class="how-inner">
        <h2>How It Works</h2>
        <p>Three simple steps to reunite you with your belongings.</p>
        <div class="steps">
            <div class="step" data-n="1">
                <div class="step-icon">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>
                </div>
                <h3>Submit a Report</h3>
                <p>Register and post a detailed description of your lost item or something you found on campus.</p>
            </div>
            <div class="step" data-n="2">
                <div class="step-icon">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
                </div>
                <h3>Match &amp; Connect</h3>
                <p>Browse reported items. If you spot a match, contact the reporter directly through the portal.</p>
            </div>
            <div class="step" data-n="3">
                <div class="step-icon">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>
                </div>
                <h3>Reclaim Your Item</h3>
                <p>Verify ownership and collect your item. Mark the report as resolved to keep the board clean.</p>
            </div>
        </div>
    </div>
</div>

<!-- FOOTER -->
<footer>
    &copy; 2026 CampusLostFound &mdash; Built for Students, By Students
</footer>

</body>
</html>
