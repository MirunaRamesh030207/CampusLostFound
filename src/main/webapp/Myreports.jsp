<%@ page language="java" contentType="text/html; charset=UTF-8" session="true" %>
<%@ page import="java.util.List, model.Item, dao.ItemDAO" %>
<%
    // Redirect if not logged in
    if (session == null || session.getAttribute("loggedUser") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    int userId = 0;
    Object userIdObj = session.getAttribute("userId");
    if (userIdObj != null) {
        userId = Integer.parseInt(userIdObj.toString());
    }

    ItemDAO dao = new ItemDAO();
    List<Item> myItems = dao.getItemsByUserId(userId);

    int myLost     = 0, myFound = 0, myResolved = 0;
    for (Item it : myItems) {
        if ("lost".equalsIgnoreCase(it.getType()))         myLost++;
        if ("found".equalsIgnoreCase(it.getType()))        myFound++;
        if ("resolved".equalsIgnoreCase(it.getStatus()))   myResolved++;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Reports — CampusLostFound</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@300;400;500;600&family=Playfair+Display:wght@700&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        :root {
            --bg:#0b0f1a; --surface:#131929; --border:#1e2d45;
            --accent:#3b82f6; --accent2:#06b6d4; --text:#e2e8f0;
            --muted:#64748b; --danger:#ef4444; --success:#22c55e;
            --warning:#f59e0b; --radius:12px;
        }
        body { font-family:'DM Sans',sans-serif; background:var(--bg); color:var(--text); min-height:100vh; }

        /* NAV */
        nav { position:sticky; top:0; z-index:100; background:rgba(11,15,26,.9); backdrop-filter:blur(16px); border-bottom:1px solid var(--border); padding:0 2rem; display:flex; align-items:center; justify-content:space-between; height:64px; }
        .nav-brand { display:flex; align-items:center; gap:.6rem; text-decoration:none; color:var(--text); }
        .nav-brand span { font-weight:600; font-size:1.05rem; }
        .nav-links { display:flex; align-items:center; gap:.25rem; list-style:none; }
        .nav-links a { display:flex; align-items:center; gap:.4rem; padding:.45rem .85rem; border-radius:8px; text-decoration:none; color:var(--muted); font-size:.875rem; font-weight:500; transition:color .2s,background .2s; }
        .nav-links a:hover { color:var(--text); background:var(--surface); }
        .nav-links a.active { color:var(--accent); background:rgba(59,130,246,.1); }
        .nav-links a svg { width:15px; height:15px; }
        .nav-user { color:var(--success); font-size:.875rem; font-weight:500; padding:.45rem .85rem; }
        .nav-logout { color:var(--danger) !important; }

        /* PAGE HEADER */
        .page-header { background:var(--surface); border-bottom:1px solid var(--border); padding:2.5rem 2rem; position:relative; overflow:hidden; }
        .page-header::before { content:''; position:absolute; top:0; left:0; right:0; height:3px; background:linear-gradient(90deg,var(--accent),var(--accent2)); }
        .header-inner { max-width:1100px; margin:0 auto; display:flex; align-items:center; justify-content:space-between; flex-wrap:wrap; gap:1rem; }
        .header-text h1 { font-family:'Playfair Display',serif; font-size:2rem; margin-bottom:.3rem; }
        .header-text p  { color:var(--muted); font-size:.9rem; }

        /* STAT CARDS */
        .stats-row { display:grid; grid-template-columns:repeat(3,1fr); gap:1rem; max-width:1100px; margin:2rem auto 0; padding:0 2rem; }
        .stat-card { background:var(--surface); border:1px solid var(--border); border-radius:var(--radius); padding:1.25rem 1.5rem; text-align:center; }
        .stat-num { font-family:'Playfair Display',serif; font-size:2rem; font-weight:700; margin-bottom:.3rem; }
        .stat-num.blue  { color:var(--accent); }
        .stat-num.red   { color:var(--danger); }
        .stat-num.green { color:var(--success); }
        .stat-label { font-size:.72rem; text-transform:uppercase; letter-spacing:.1em; color:var(--muted); font-weight:500; }

        /* MAIN */
        .main { max-width:1100px; margin:2rem auto; padding:0 2rem 3rem; }
        .section-title { font-size:1.1rem; font-weight:600; margin-bottom:1.25rem; display:flex; align-items:center; gap:.5rem; }
        .section-title svg { color:var(--accent); width:18px; height:18px; }

        /* ITEMS GRID */
        .items-grid { display:grid; grid-template-columns:repeat(auto-fill,minmax(300px,1fr)); gap:1rem; }

        /* ITEM CARD */
        .item-card { background:var(--surface); border:1px solid var(--border); border-radius:var(--radius); overflow:hidden; transition:border-color .2s,transform .2s,box-shadow .2s; animation:fadeUp .3s ease both; }
        .item-card:hover { border-color:rgba(59,130,246,.35); transform:translateY(-2px); box-shadow:0 8px 30px rgba(0,0,0,.3); }
        .card-img-wrap { width:100%; height:160px; overflow:hidden; background:var(--bg); }
        .card-img-wrap img { width:100%; height:100%; object-fit:cover; display:block; transition:transform .35s; }
        .item-card:hover .card-img-wrap img { transform:scale(1.05); }
        .card-no-img { width:100%; height:160px; background:var(--bg); display:flex; align-items:center; justify-content:center; border-bottom:1px solid var(--border); }
        .card-no-img svg { width:40px; height:40px; opacity:.12; }
        .card-body { padding:1.1rem 1.25rem 1.25rem; }
        .card-top { display:flex; align-items:flex-start; justify-content:space-between; margin-bottom:.65rem; gap:.5rem; }
        .card-badges { display:flex; gap:.4rem; flex-wrap:wrap; }
        .badge { font-size:.68rem; font-weight:600; letter-spacing:.07em; text-transform:uppercase; padding:.22rem .65rem; border-radius:6px; }
        .badge-lost     { background:rgba(239,68,68,.15);   color:var(--danger); }
        .badge-found    { background:rgba(34,197,94,.15);   color:var(--success); }
        .badge-open     { background:rgba(59,130,246,.12);  color:var(--accent); }
        .badge-resolved { background:rgba(100,116,139,.12); color:var(--muted); }
        .card-title    { font-weight:600; font-size:1rem; margin-bottom:.25rem; }
        .card-category { font-size:.75rem; color:var(--muted); margin-bottom:.5rem; }
        .card-meta { display:flex; align-items:center; gap:.35rem; font-size:.8rem; color:var(--muted); margin-bottom:.65rem; }
        .card-meta svg { width:13px; height:13px; flex-shrink:0; }
        .card-desc { font-size:.84rem; color:#94a3b8; line-height:1.55; margin-bottom:1rem; display:-webkit-box; -webkit-line-clamp:2; -webkit-box-orient:vertical; overflow:hidden; }
        .card-footer { display:flex; align-items:center; justify-content:space-between; padding-top:.75rem; border-top:1px solid var(--border); gap:.5rem; }

        /* ACTION BUTTONS */
        .btn-sm { display:inline-flex; align-items:center; gap:.35rem; padding:.4rem .85rem; border-radius:7px; font-family:'DM Sans',sans-serif; font-size:.78rem; font-weight:500; text-decoration:none; border:none; cursor:pointer; transition:all .2s; }
        .btn-resolve  { background:rgba(34,197,94,.12);  color:var(--success); border:1px solid rgba(34,197,94,.25); }
        .btn-resolve:hover  { background:var(--success); color:#fff; }
        .btn-delete   { background:rgba(239,68,68,.1);   color:var(--danger);  border:1px solid rgba(239,68,68,.2); }
        .btn-delete:hover   { background:var(--danger);  color:#fff; }
        .btn-resolved-tag { background:rgba(100,116,139,.12); color:var(--muted); border:1px solid var(--border); cursor:default; }

        /* DELETE BUTTON TOP RIGHT */
        .delete-btn { width:28px; height:28px; border-radius:6px; display:flex; align-items:center; justify-content:center; color:var(--muted); text-decoration:none; border:1px solid var(--border); background:var(--bg); transition:all .2s; flex-shrink:0; }
        .delete-btn:hover { background:rgba(239,68,68,.12); border-color:var(--danger); color:var(--danger); }
        .delete-btn svg { width:13px; height:13px; }

        /* EMPTY STATE */
        .empty-state { text-align:center; padding:5rem 2rem; color:var(--muted); }
        .empty-state svg { opacity:.15; margin-bottom:1.25rem; display:block; margin-left:auto; margin-right:auto; }
        .empty-state h3 { font-size:1.1rem; font-weight:600; color:var(--text); margin-bottom:.5rem; }
        .empty-state p  { font-size:.9rem; margin-bottom:1.5rem; }
        .btn-primary { display:inline-flex; align-items:center; gap:.5rem; padding:.7rem 1.4rem; border-radius:9px; background:var(--accent); color:#fff; text-decoration:none; font-size:.9rem; font-weight:500; transition:all .2s; border:none; cursor:pointer; }
        .btn-primary:hover { background:#2563eb; transform:translateY(-1px); }

        /* REPORT NEW BTN */
        .btn-report { display:inline-flex; align-items:center; gap:.4rem; padding:.6rem 1.2rem; border-radius:9px; background:var(--accent); color:#fff; text-decoration:none; font-size:.875rem; font-weight:500; transition:all .2s; }
        .btn-report:hover { background:#2563eb; transform:translateY(-1px); }
        .btn-report svg { width:15px; height:15px; }

        @keyframes fadeUp { from{opacity:0;transform:translateY(12px)} to{opacity:1;transform:translateY(0)} }
        @media(max-width:768px) { .nav-links{display:none} .stats-row{grid-template-columns:1fr 1fr} }
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
    <ul class="nav-links">
        <li><a href="index.jsp">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/><polyline points="9 22 9 12 15 12 15 22"/></svg>Home</a></li>
        <li><a href="searchItem.jsp">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>Browse</a></li>
        <li><a href="postItem.jsp">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>Report Item</a></li>
        <li><a href="myReports.jsp" class="active">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/></svg>My Reports</a></li>
        <li><span class="nav-user">Hi, <%= session.getAttribute("userName") %> &#128075;</span></li>
        <li><a href="LogoutServlet" class="nav-logout">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg>Logout</a></li>
    </ul>
</nav>

<!-- PAGE HEADER -->
<div class="page-header">
    <div class="header-inner">
        <div class="header-text">
            <h1>My Reports</h1>
            <p>All items you have reported — lost and found</p>
        </div>
        <a href="postItem.jsp" class="btn-report">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
            Report New Item
        </a>
    </div>
</div>

<!-- STATS -->
<div class="stats-row">
    <div class="stat-card">
        <div class="stat-num blue"><%= myItems.size() %></div>
        <div class="stat-label">Total Reports</div>
    </div>
    <div class="stat-card">
        <div class="stat-num red"><%= myLost %></div>
        <div class="stat-label">Lost Items</div>
    </div>
    <div class="stat-card">
        <div class="stat-num green"><%= myResolved %></div>
        <div class="stat-label">Resolved</div>
    </div>
</div>

<!-- ITEMS -->
<div class="main">
    <div class="section-title">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
        Your Reported Items
    </div>

    <% if (myItems.isEmpty()) { %>
        <div class="empty-state">
            <svg width="64" height="64" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/>
            </svg>
            <h3>No reports yet</h3>
            <p>You haven't posted any lost or found reports</p>
            <a href="postItem.jsp" class="btn-primary">Report an Item</a>
        </div>
    <% } else { %>
        <div class="items-grid">
        <% int delay = 0;
           for (Item item : myItems) {
               boolean isLost     = "lost".equalsIgnoreCase(item.getType());
               boolean isResolved = "resolved".equalsIgnoreCase(item.getStatus());
               String typeBadge   = isLost ? "badge-lost"  : "badge-found";
               String typeText    = isLost ? "Lost"        : "Found";
               String statusBadge = isResolved ? "badge-resolved" : "badge-open";
               String statusText  = isResolved ? "Resolved"       : "Open";
               String itemName    = item.getItemName()    != null ? item.getItemName()    : item.getCategory();
               String category    = item.getCategory()    != null ? item.getCategory()    : "";
               String location    = item.getLocation()    != null ? item.getLocation()    : "Campus";
               String datePost    = item.getDatePost()    != null ? item.getDatePost()    : "";
               String desc        = item.getDescription() != null ? item.getDescription() : "";
               String imageName   = item.getImageName();
               delay += 50;
        %>
            <div class="item-card" style="animation-delay:<%= delay %>ms">

                <% if (imageName != null && !imageName.trim().isEmpty()) { %>
                    <div class="card-img-wrap">
                        <img src="uploads/<%= imageName %>" alt="<%= itemName %>">
                    </div>
                <% } else { %>
                    <div class="card-no-img">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
                            <rect x="3" y="3" width="18" height="18" rx="2" ry="2"/><circle cx="8.5" cy="8.5" r="1.5"/><polyline points="21 15 16 10 5 21"/>
                        </svg>
                    </div>
                <% } %>

                <div class="card-body">
                    <div class="card-top">
                        <div class="card-badges">
                            <span class="badge <%= typeBadge %>"><%= typeText %></span>
                            <span class="badge <%= statusBadge %>"><%= statusText %></span>
                        </div>
                        <!-- DELETE TOP RIGHT -->
                        <a href="DeleteItemServlet?id=<%= item.getItemId() %>&from=myReports.jsp"
                           class="delete-btn"
                           onclick="return confirm('Delete this item?')" title="Delete">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <polyline points="3 6 5 6 21 6"/>
                                <path d="M19 6l-1 14a2 2 0 0 1-2 2H8a2 2 0 0 1-2-2L5 6"/>
                                <path d="M10 11v6M14 11v6"/><path d="M9 6V4h6v2"/>
                            </svg>
                        </a>
                    </div>

                    <div class="card-title"><%= itemName %></div>
                    <div class="card-category"><%= category %></div>
                    <div class="card-meta">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/>
                        </svg>
                        <%= location %> &mdash; <%= datePost %>
                    </div>
                    <div class="card-desc"><%= desc %></div>

                    <div class="card-footer">
                        <% if (isResolved) { %>
                            <span class="btn-sm btn-resolved-tag">&#10003; Resolved</span>
                        <% } else { %>
                            <a href="ResolveItemServlet?id=<%= item.getItemId() %>&from=myReports.jsp"
                               class="btn-sm btn-resolve"
                               onclick="return confirm('Mark this item as resolved?')">
                                &#10003; Mark Resolved
                            </a>
                        <% } %>
                        <a href="DeleteItemServlet?id=<%= item.getItemId() %>&from=myReports.jsp"
                           class="btn-sm btn-delete"
                           onclick="return confirm('Delete this item?')">
                            Delete
                        </a>
                    </div>
                </div>
            </div>
        <% } %>
        </div>
    <% } %>
</div>

</body>
</html>
