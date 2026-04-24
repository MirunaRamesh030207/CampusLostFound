<%@ page language="java" contentType="text/html; charset=UTF-8" session="true" %>
<%@ page import="java.util.List, java.util.ArrayList, model.Item, dao.ItemDAO" %>
<%
    ItemDAO itemDAO  = new ItemDAO();
    List<Item> allItems = itemDAO.getAllItems();

    String filterType     = request.getParameter("type")     != null ? request.getParameter("type")     : "all";
    String filterCategory = request.getParameter("category") != null ? request.getParameter("category") : "all";
    String filterLocation = request.getParameter("location") != null ? request.getParameter("location") : "all";
    String searchQuery    = request.getParameter("search")   != null ? request.getParameter("search").toLowerCase().trim() : "";

    List<Item> filteredItems = new ArrayList<>();
    for (Item item : allItems) {
        boolean matchType     = filterType.equals("all")     || filterType.equalsIgnoreCase(item.getType());
        boolean matchCategory = filterCategory.equals("all") || filterCategory.equalsIgnoreCase(item.getCategory());
        boolean matchLocation = filterLocation.equals("all") || filterLocation.equalsIgnoreCase(item.getLocation());
        boolean matchSearch   = searchQuery.isEmpty()
            || (item.getItemName()    != null && item.getItemName().toLowerCase().contains(searchQuery))
            || (item.getDescription() != null && item.getDescription().toLowerCase().contains(searchQuery))
            || (item.getLocation()    != null && item.getLocation().toLowerCase().contains(searchQuery))
            || (item.getCategory()    != null && item.getCategory().toLowerCase().contains(searchQuery));
        if (matchType && matchCategory && matchLocation && matchSearch) {
            filteredItems.add(item);
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Browse Items — CampusLostFound</title>
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
        body { font-family: 'DM Sans', sans-serif; background: var(--bg); color: var(--text); min-height: 100vh; }

        /* NAV */
        nav { position: sticky; top: 0; z-index: 100; background: rgba(11,15,26,.9); backdrop-filter: blur(16px); border-bottom: 1px solid var(--border); padding: 0 2rem; display: flex; align-items: center; justify-content: space-between; height: 64px; }
        .nav-brand { display: flex; align-items: center; gap: .6rem; text-decoration: none; color: var(--text); }
        .nav-brand span { font-weight: 600; font-size: 1.05rem; }
        .nav-links { display: flex; align-items: center; gap: .25rem; list-style: none; }
        .nav-links a { display: flex; align-items: center; gap: .4rem; padding: .45rem .85rem; border-radius: 8px; text-decoration: none; color: var(--muted); font-size: .875rem; font-weight: 500; transition: color .2s, background .2s; }
        .nav-links a:hover { color: var(--text); background: var(--surface); }
        .nav-links a.active { color: var(--accent); background: rgba(59,130,246,.1); }
        .nav-links a svg { width: 15px; height: 15px; }
        .nav-cta { background: var(--accent) !important; color: white !important; border-radius: 8px; }
        .nav-user { color: var(--success); font-size: .875rem; font-weight: 500; padding: .45rem .85rem; }
        .nav-logout { color: var(--danger) !important; }
        .nav-logout:hover { background: rgba(239,68,68,.08) !important; }

        /* PAGE HEADER */
        .page-header { background: var(--surface); border-bottom: 1px solid var(--border); padding: 2.5rem 2rem; position: relative; overflow: hidden; }
        .page-header::before { content: ''; position: absolute; top: 0; left: 0; right: 0; height: 3px; background: linear-gradient(90deg, var(--accent), var(--accent2)); }
        .page-header::after  { content: ''; position: absolute; inset: 0; background: radial-gradient(ellipse 40% 80% at 100% 50%, rgba(6,182,212,.06) 0%, transparent 70%); pointer-events: none; }
        .header-inner { max-width: 1100px; margin: 0 auto; display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 1rem; }
        .header-inner h1 { font-family: 'Playfair Display', serif; font-size: 2rem; margin-bottom: .3rem; }
        .header-inner p  { color: var(--muted); font-size: .9rem; }

        /* MAIN */
        .main { max-width: 1100px; margin: 0 auto; padding: 2rem; }

        /* SEARCH + FILTERS */
        .filters-bar { display: flex; gap: .75rem; margin-bottom: 1.25rem; flex-wrap: wrap; align-items: center; }
        .search-wrap { position: relative; flex: 1; min-width: 220px; }
        .search-wrap svg { position: absolute; left: .9rem; top: 50%; transform: translateY(-50%); width: 16px; height: 16px; color: var(--muted); pointer-events: none; }
        .search-input { width: 100%; background: var(--surface); border: 1px solid var(--border); border-radius: 10px; padding: .72rem 1rem .72rem 2.5rem; color: var(--text); font-family: 'DM Sans', sans-serif; font-size: .9rem; outline: none; transition: border .2s, box-shadow .2s; }
        .search-input:focus { border-color: var(--accent); box-shadow: 0 0 0 3px rgba(59,130,246,.12); }
        .search-input::placeholder { color: var(--muted); }
        .filter-select { background: var(--surface); border: 1px solid var(--border); border-radius: 10px; padding: .72rem 1rem; color: var(--text); font-family: 'DM Sans', sans-serif; font-size: .875rem; outline: none; cursor: pointer; transition: border .2s; appearance: none; min-width: 140px; }
        .filter-select:focus { border-color: var(--accent); }
        .filter-select option { background: #131929; }
        .btn-search { background: var(--accent); color: #fff; border: none; border-radius: 10px; padding: .72rem 1.4rem; font-family: 'DM Sans', sans-serif; font-size: .9rem; font-weight: 500; cursor: pointer; transition: all .2s; white-space: nowrap; }
        .btn-search:hover { background: #2563eb; }
        .btn-clear { background: transparent; color: var(--muted); border: 1px solid var(--border); border-radius: 10px; padding: .72rem 1rem; font-family: 'DM Sans', sans-serif; font-size: .875rem; cursor: pointer; transition: all .2s; text-decoration: none; display: inline-flex; align-items: center; white-space: nowrap; }
        .btn-clear:hover { border-color: var(--danger); color: var(--danger); }

        /* FILTER PILLS */
        .filter-pills { display: flex; gap: .5rem; flex-wrap: wrap; margin-bottom: 1.5rem; align-items: center; }
        .pill-label { font-size: .78rem; color: var(--muted); margin-right: .25rem; }
        .pill { padding: .35rem .9rem; border-radius: 100px; font-size: .8rem; font-weight: 500; border: 1px solid var(--border); background: var(--surface); color: var(--muted); cursor: pointer; transition: all .2s; text-decoration: none; display: inline-block; }
        .pill:hover { border-color: var(--accent); color: var(--accent); }
        .pill.pill-all   { border-color: var(--accent);  background: rgba(59,130,246,.12); color: var(--accent); }
        .pill.pill-lost  { border-color: var(--danger);  background: rgba(239,68,68,.12);  color: var(--danger); }
        .pill.pill-found { border-color: var(--success); background: rgba(34,197,94,.12);  color: var(--success); }

        /* RESULTS ROW */
        .results-row { display: flex; align-items: center; justify-content: space-between; margin-bottom: 1.25rem; flex-wrap: wrap; gap: .75rem; }
        .results-count { font-size: .875rem; color: var(--muted); }
        .results-count strong { color: var(--text); }
        .btn-report { display: inline-flex; align-items: center; gap: .4rem; padding: .6rem 1.2rem; border-radius: 9px; background: var(--accent); color: #fff; text-decoration: none; font-size: .875rem; font-weight: 500; transition: all .2s; border: none; cursor: pointer; }
        .btn-report:hover { background: #2563eb; transform: translateY(-1px); }
        .btn-report svg { width: 15px; height: 15px; }

        /* ITEMS GRID */
        .items-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); gap: 1rem; }

        /* ITEM CARD */
        .item-card { background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius); overflow: hidden; transition: border-color .2s, transform .2s, box-shadow .2s; animation: fadeUp .3s ease both; }
        .item-card:hover { border-color: rgba(59,130,246,.35); transform: translateY(-2px); box-shadow: 0 8px 30px rgba(0,0,0,.3); }

        /* Card Image */
        .card-img-wrap { width: 100%; height: 170px; overflow: hidden; background: var(--bg); }
        .card-img-wrap img { width: 100%; height: 100%; object-fit: cover; display: block; transition: transform .35s; }
        .item-card:hover .card-img-wrap img { transform: scale(1.05); }
        .card-no-img { width: 100%; height: 170px; background: var(--bg); display: flex; align-items: center; justify-content: center; border-bottom: 1px solid var(--border); }
        .card-no-img svg { width: 44px; height: 44px; opacity: .12; }

        /* Card Body */
        .card-body { padding: 1.1rem 1.25rem 1.25rem; }
        .card-top  { display: flex; align-items: flex-start; justify-content: space-between; margin-bottom: .65rem; gap: .5rem; }
        .card-badges { display: flex; gap: .4rem; flex-wrap: wrap; }
        .badge { font-size: .68rem; font-weight: 600; letter-spacing: .07em; text-transform: uppercase; padding: .22rem .65rem; border-radius: 6px; }
        .badge-lost     { background: rgba(239,68,68,.15);  color: var(--danger); }
        .badge-found    { background: rgba(34,197,94,.15);  color: var(--success); }
        .badge-open     { background: rgba(59,130,246,.12); color: var(--accent); }
        .badge-resolved { background: rgba(100,116,139,.12); color: var(--muted); }

        /* ── DELETE BUTTON ── */
        .delete-btn { width: 30px; height: 30px; border-radius: 7px; display: flex; align-items: center; justify-content: center; color: var(--muted); text-decoration: none; border: 1px solid var(--border); background: var(--bg); transition: all .2s; flex-shrink: 0; cursor: pointer; }
        .delete-btn:hover { background: rgba(239,68,68,.12); border-color: var(--danger); color: var(--danger); }
        .delete-btn svg { width: 14px; height: 14px; }

        .card-title { font-weight: 600; font-size: 1rem; margin-bottom: .25rem; }
        .card-category { font-size: .75rem; color: var(--muted); margin-bottom: .55rem; font-weight: 500; }
        .card-meta { display: flex; align-items: center; gap: .35rem; font-size: .8rem; color: var(--muted); margin-bottom: .65rem; }
        .card-meta svg { width: 13px; height: 13px; flex-shrink: 0; }
        .card-desc { font-size: .84rem; color: #94a3b8; line-height: 1.55; margin-bottom: 1rem; display: -webkit-box; -webkit-line-clamp: 3; -webkit-box-orient: vertical; overflow: hidden; }
        .card-footer { display: flex; align-items: center; justify-content: space-between; padding-top: .75rem; border-top: 1px solid var(--border); }
        .card-date { font-size: .75rem; color: var(--muted); }

        /* Buttons */
        .btn-sm { display: inline-flex; align-items: center; gap: .35rem; padding: .4rem .9rem; border-radius: 7px; font-family: 'DM Sans', sans-serif; font-size: .8rem; font-weight: 500; text-decoration: none; border: none; cursor: pointer; transition: all .2s; }
        .btn-contact  { background: var(--surface); color: var(--text); border: 1px solid var(--border); }
        .btn-contact:hover  { border-color: var(--accent); color: var(--accent); }
        .btn-claim    { background: var(--success); color: #fff; }
        .btn-claim:hover    { background: #16a34a; }
        .btn-resolved { background: var(--surface); color: var(--muted); border: 1px solid var(--border); cursor: default; font-size: .75rem; }

        /* EMPTY STATE */
        .empty-state { grid-column: 1 / -1; text-align: center; padding: 5rem 2rem; color: var(--muted); }
        .empty-state svg { opacity: .15; margin-bottom: 1.25rem; display: block; margin-left: auto; margin-right: auto; }
        .empty-state h3 { font-size: 1.1rem; font-weight: 600; color: var(--text); margin-bottom: .5rem; }
        .empty-state p  { font-size: .9rem; margin-bottom: 1.5rem; }
        .btn-primary { display: inline-flex; align-items: center; gap: .5rem; padding: .7rem 1.4rem; border-radius: 9px; background: var(--accent); color: #fff; text-decoration: none; font-size: .9rem; font-weight: 500; transition: all .2s; border: none; cursor: pointer; }
        .btn-primary:hover { background: #2563eb; transform: translateY(-1px); }

        /* ANIMATION */
        @keyframes fadeUp { from { opacity: 0; transform: translateY(12px); } to { opacity: 1; transform: translateY(0); } }

        /* RESPONSIVE */
        @media (max-width: 768px) { .nav-links { display: none; } .filters-bar { flex-direction: column; } .filter-select { width: 100%; } }
        @media (max-width: 480px) { .main { padding: 1.25rem; } }
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
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/><polyline points="9 22 9 12 15 12 15 22"/></svg>
            Home
        </a></li>
        <li><a href="searchItem.jsp" class="active">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
            Browse Items
        </a></li>
        <li><a href="postItem.jsp">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
            Report Item
        </a></li>
        <% if (session != null && session.getAttribute("loggedUser") != null) { %>
            <li><span class="nav-user">Hi, <%= session.getAttribute("userName") %> &#128075;</span></li>
            <li><a href="LogoutServlet" class="nav-logout">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg>
                Logout
            </a></li>
        <% } else { %>
            <li><a href="login.jsp">Login</a></li>
            <li><a href="register.jsp" class="nav-cta btn">Register</a></li>
        <% } %>
    </ul>
</nav>

<!-- PAGE HEADER -->
<div class="page-header">
    <div class="header-inner">
        <div>
            <h1>Browse Items</h1>
            <p>Search through all lost and found reports across campus</p>
        </div>
        <a href="postItem.jsp" class="btn-report">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
            Report Item
        </a>
    </div>
</div>

<!-- MAIN -->
<div class="main">

    <form method="get" action="searchItem.jsp">
        <div class="filters-bar">
            <div class="search-wrap">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
                <input type="text" name="search" class="search-input"
                       placeholder="Search by name, location, description..."
                       value="<%= searchQuery %>">
            </div>
            <select name="category" class="filter-select" onchange="this.form.submit()">
                <option value="all"         <%= filterCategory.equals("all")          ? "selected" : "" %>>All Categories</option>
                <option value="Electronics" <%= filterCategory.equals("Electronics")  ? "selected" : "" %>>Electronics</option>
                <option value="Bags"        <%= filterCategory.equals("Bags")         ? "selected" : "" %>>Bags</option>
                <option value="Keys"        <%= filterCategory.equals("Keys")         ? "selected" : "" %>>Keys</option>
                <option value="Documents"   <%= filterCategory.equals("Documents")    ? "selected" : "" %>>Documents</option>
                <option value="Clothing"    <%= filterCategory.equals("Clothing")     ? "selected" : "" %>>Clothing</option>
                <option value="Books"       <%= filterCategory.equals("Books")        ? "selected" : "" %>>Books</option>
                <option value="Accessories" <%= filterCategory.equals("Accessories")  ? "selected" : "" %>>Accessories</option>
                <option value="Sports"      <%= filterCategory.equals("Sports")       ? "selected" : "" %>>Sports</option>
                <option value="Other"       <%= filterCategory.equals("Other")        ? "selected" : "" %>>Other</option>
            </select>
            <select name="location" class="filter-select" onchange="this.form.submit()">
                <option value="all"        <%= filterLocation.equals("all")        ? "selected" : "" %>>All Locations</option>
                <option value="Library"    <%= filterLocation.equals("Library")    ? "selected" : "" %>>Library</option>
                <option value="Canteen"    <%= filterLocation.equals("Canteen")    ? "selected" : "" %>>Canteen</option>
                <option value="Block A"    <%= filterLocation.equals("Block A")    ? "selected" : "" %>>Block A</option>
                <option value="Block B"    <%= filterLocation.equals("Block B")    ? "selected" : "" %>>Block B</option>
                <option value="Block C"    <%= filterLocation.equals("Block C")    ? "selected" : "" %>>Block C</option>
                <option value="Block D"    <%= filterLocation.equals("Block D")    ? "selected" : "" %>>Block D</option>
                <option value="Hostel"     <%= filterLocation.equals("Hostel")     ? "selected" : "" %>>Hostel</option>
                <option value="Playground" <%= filterLocation.equals("Playground") ? "selected" : "" %>>Playground</option>
                <option value="Parking"    <%= filterLocation.equals("Parking")    ? "selected" : "" %>>Parking</option>
                <option value="Auditorium" <%= filterLocation.equals("Auditorium") ? "selected" : "" %>>Auditorium</option>
                <option value="Labs"       <%= filterLocation.equals("Labs")       ? "selected" : "" %>>Labs</option>
                <option value="Other"      <%= filterLocation.equals("Other")      ? "selected" : "" %>>Other</option>
            </select>
            <button type="submit" class="btn-search">Search</button>
            <a href="searchItem.jsp" class="btn-clear">Clear</a>
        </div>

        <div class="filter-pills">
            <span class="pill-label">Filter:</span>
            <a href="searchItem.jsp?type=all&category=<%= filterCategory %>&location=<%= filterLocation %>&search=<%= searchQuery %>"
               class="pill <%= filterType.equals("all")   ? "pill-all"   : "" %>">All Items</a>
            <a href="searchItem.jsp?type=lost&category=<%= filterCategory %>&location=<%= filterLocation %>&search=<%= searchQuery %>"
               class="pill <%= filterType.equals("lost")  ? "pill-lost"  : "" %>">Lost Only</a>
            <a href="searchItem.jsp?type=found&category=<%= filterCategory %>&location=<%= filterLocation %>&search=<%= searchQuery %>"
               class="pill <%= filterType.equals("found") ? "pill-found" : "" %>">Found Only</a>
            <input type="hidden" name="type" value="<%= filterType %>">
        </div>
    </form>

    <div class="results-row">
        <div class="results-count">
            Showing <strong><%= filteredItems.size() %></strong> of
            <strong><%= allItems.size() %></strong> reports
            <% if (!searchQuery.isEmpty()) { %>
                for &ldquo;<strong><%= searchQuery %></strong>&rdquo;
            <% } %>
        </div>
        <a href="postItem.jsp" class="btn-report">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
            Report New Item
        </a>
    </div>

    <!-- ITEMS GRID -->
    <div class="items-grid">
    <%
        if (filteredItems.isEmpty()) {
    %>
        <div class="empty-state">
            <svg width="64" height="64" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.2" stroke-linecap="round" stroke-linejoin="round">
                <circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/>
            </svg>
            <h3>No items found</h3>
            <p>Try adjusting your search or filters</p>
            <a href="postItem.jsp" class="btn-primary">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="width:16px;height:16px"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
                Report an Item
            </a>
        </div>
    <%
        } else {
            int delay = 0;
            for (Item item : filteredItems) {
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
                        <rect x="3" y="3" width="18" height="18" rx="2" ry="2"/>
                        <circle cx="8.5" cy="8.5" r="1.5"/>
                        <polyline points="21 15 16 10 5 21"/>
                    </svg>
                </div>
            <% } %>

            <div class="card-body">
                <div class="card-top">
                    <div class="card-badges">
                        <span class="badge <%= typeBadge %>"><%= typeText %></span>
                        <span class="badge <%= statusBadge %>"><%= statusText %></span>
                    </div>

                    <%-- DELETE BUTTON TOP RIGHT --%>
                    <a href="DeleteItemServlet?id=<%= item.getItemId() %>"
                       class="delete-btn"
                       onclick="return confirm('Are you sure you want to delete this item?')"
                       title="Delete this item">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
                             stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <polyline points="3 6 5 6 21 6"/>
                            <path d="M19 6l-1 14a2 2 0 0 1-2 2H8a2 2 0 0 1-2-2L5 6"/>
                            <path d="M10 11v6M14 11v6"/>
                            <path d="M9 6V4h6v2"/>
                        </svg>
                    </a>
                </div>

                <div class="card-title"><%= itemName %></div>
                <div class="card-category"><%= category %></div>

                <div class="card-meta">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/>
                    </svg>
                    <%= location %>
                </div>

                <div class="card-desc"><%= desc %></div>

                <div class="card-footer">
                    <span class="card-date"><%= datePost %></span>
                    <% if (isResolved) { %>
                        <span class="btn-sm btn-resolved">Resolved</span>
                    <% } else if (isLost) { %>
                        <a href="contactItem.jsp?id=<%= item.getItemId() %>" class="btn-sm btn-contact">Contact</a>
                    <% } else { %>
                        <a href="contactItem.jsp?id=<%= item.getItemId() %>" class="btn-sm btn-claim">Claim</a>
                    <% } %>
                </div>
            </div>
        </div>
    <%
            }
        }
    %>
    </div>
</div>

</body>
</html>
