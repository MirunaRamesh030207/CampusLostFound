<%@ page language="java" contentType="text/html; charset=UTF-8" session="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Report Item — CampusLostFound</title>
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
        body { font-family: 'DM Sans', sans-serif; background: var(--bg); color: var(--text); min-height: 100vh; display: flex; flex-direction: column; }

        /* NAV */
        nav { position: sticky; top: 0; z-index: 100; background: rgba(11,15,26,.9); backdrop-filter: blur(16px); border-bottom: 1px solid var(--border); padding: 0 2rem; display: flex; align-items: center; justify-content: space-between; height: 64px; }
        .nav-brand { display: flex; align-items: center; gap: .6rem; text-decoration: none; color: var(--text); }
        .nav-brand span { font-weight: 600; font-size: 1.05rem; }
        .nav-right { display: flex; align-items: center; gap: 1rem; }
        .nav-link { color: var(--muted); text-decoration: none; font-size: .875rem; font-weight: 500; transition: color .2s; }
        .nav-link:hover { color: var(--text); }

        /* PAGE HEADER */
        .page-header { background: var(--surface); border-bottom: 1px solid var(--border); padding: 2.5rem 2rem 2rem; position: relative; overflow: hidden; }
        .page-header::before { content: ''; position: absolute; top: 0; left: 0; right: 0; height: 3px; background: linear-gradient(90deg, var(--accent), var(--accent2)); }
        .page-header::after { content: ''; position: absolute; inset: 0; background: radial-gradient(ellipse 50% 80% at 0% 50%, rgba(59,130,246,.08) 0%, transparent 70%); pointer-events: none; }
        .header-inner { max-width: 860px; margin: 0 auto; display: flex; align-items: flex-start; gap: 1.25rem; }
        .header-icon { width: 52px; height: 52px; border-radius: 14px; flex-shrink: 0; display: flex; align-items: center; justify-content: center; }
        .header-icon svg { width: 24px; height: 24px; }
        .header-icon.lost  { background: rgba(239,68,68,.12); color: var(--danger);  border: 1px solid rgba(239,68,68,.2); }
        .header-icon.found { background: rgba(34,197,94,.12);  color: var(--success); border: 1px solid rgba(34,197,94,.2); }
        .header-text h1 { font-family: 'Playfair Display', serif; font-size: 1.6rem; margin-bottom: .3rem; }
        .header-text p  { color: var(--muted); font-size: .9rem; line-height: 1.6; }

        /* TYPE TOGGLE */
        .type-toggle { max-width: 860px; margin: 2rem auto 0; display: grid; grid-template-columns: 1fr 1fr; gap: .75rem; padding: 0 2rem; }
        .type-btn { display: flex; align-items: center; gap: .75rem; padding: 1rem 1.25rem; border-radius: var(--radius); border: 2px solid var(--border); background: var(--surface); cursor: pointer; transition: all .2s; font-family: 'DM Sans', sans-serif; color: var(--muted); text-align: left; }
        .type-btn:hover { border-color: var(--muted); color: var(--text); }
        .type-btn.active-lost  { border-color: var(--danger);  background: rgba(239,68,68,.06);  color: var(--danger); }
        .type-btn.active-found { border-color: var(--success); background: rgba(34,197,94,.06);  color: var(--success); }
        .type-btn-icon { width: 38px; height: 38px; border-radius: 9px; flex-shrink: 0; display: flex; align-items: center; justify-content: center; }
        .type-btn.active-lost  .type-btn-icon { background: rgba(239,68,68,.15); }
        .type-btn.active-found .type-btn-icon { background: rgba(34,197,94,.15); }
        .type-btn svg { width: 18px; height: 18px; }
        .type-btn-label { font-weight: 600; font-size: .95rem; display: block; }
        .type-btn-sub   { font-size: .78rem; color: var(--muted); margin-top: .1rem; display: block; }

        /* MAIN LAYOUT */
        .main { flex: 1; max-width: 860px; margin: 0 auto; padding: 2rem; width: 100%; display: grid; grid-template-columns: 1fr 340px; gap: 1.5rem; align-items: start; }

        /* FORM CARD */
        .form-card { background: var(--surface); border: 1px solid var(--border); border-radius: 16px; padding: 1.75rem; animation: fadeUp .4s ease both; }

        .section-label { font-size: .72rem; font-weight: 600; letter-spacing: .1em; text-transform: uppercase; color: var(--muted); display: flex; align-items: center; gap: .6rem; margin-bottom: 1.1rem; margin-top: 1.5rem; }
        .section-label:first-child { margin-top: 0; }
        .section-label::after { content: ''; flex: 1; height: 1px; background: var(--border); }

        .form-group { margin-bottom: 1rem; }
        label.field-label { display: block; font-size: .78rem; font-weight: 600; letter-spacing: .06em; text-transform: uppercase; color: var(--muted); margin-bottom: .45rem; }

        input[type="text"],
        input[type="date"],
        select,
        textarea {
            width: 100%; background: var(--bg); border: 1px solid var(--border); border-radius: 9px; padding: .72rem 1rem; color: var(--text); font-family: 'DM Sans', sans-serif; font-size: .9rem; transition: border .2s, box-shadow .2s; outline: none; appearance: none;
        }
        input:focus, select:focus, textarea:focus { border-color: var(--accent); box-shadow: 0 0 0 3px rgba(59,130,246,.12); }
        input::placeholder, textarea::placeholder { color: var(--muted); }
        select option { background: #131929; }
        textarea { resize: vertical; min-height: 100px; line-height: 1.6; }
        .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; }

        /* ALERTS */
        .alert { border-radius: 9px; padding: .75rem 1rem; font-size: .875rem; margin-bottom: 1.25rem; display: flex; align-items: center; gap: .5rem; }
        .alert svg { width: 16px; height: 16px; flex-shrink: 0; }
        .alert-error   { background: rgba(239,68,68,.1);  border: 1px solid rgba(239,68,68,.25);  color: var(--danger); }
        .alert-success { background: rgba(34,197,94,.1);  border: 1px solid rgba(34,197,94,.25);  color: var(--success); }

        /* SUBMIT BUTTON */
        .btn-submit { width: 100%; border: none; border-radius: 9px; padding: .9rem; font-family: 'DM Sans', sans-serif; font-size: .95rem; font-weight: 600; cursor: pointer; display: flex; align-items: center; justify-content: center; gap: .5rem; margin-top: 1.5rem; transition: all .2s; }
        .btn-submit.lost-btn  { background: var(--danger);  color: #fff; }
        .btn-submit.found-btn { background: var(--success); color: #fff; }
        .btn-submit:hover { opacity: .9; transform: translateY(-1px); box-shadow: 0 6px 20px rgba(0,0,0,.3); }
        .btn-submit svg { width: 18px; height: 18px; }

        /* IMAGE UPLOAD PANEL */
        .upload-panel { background: var(--surface); border: 1px solid var(--border); border-radius: 16px; overflow: hidden; animation: fadeUp .4s .1s ease both; position: sticky; top: 84px; }
        .upload-panel-header { padding: 1.1rem 1.4rem; border-bottom: 1px solid var(--border); display: flex; align-items: center; gap: .6rem; }
        .upload-panel-header svg { width: 16px; height: 16px; color: var(--accent); }
        .upload-panel-header span { font-size: .8rem; font-weight: 600; letter-spacing: .06em; text-transform: uppercase; color: var(--muted); }
        .tip-badge { margin-left: auto; background: rgba(59,130,246,.12); color: var(--accent); font-size: .68rem; font-weight: 600; letter-spacing: .05em; text-transform: uppercase; padding: .2rem .55rem; border-radius: 5px; }

        /* DROP ZONE */
        .drop-zone { margin: 1.25rem; border: 2px dashed var(--border); border-radius: 12px; padding: 2rem 1rem; text-align: center; cursor: pointer; transition: all .25s; position: relative; background: var(--bg); min-height: 180px; display: flex; flex-direction: column; align-items: center; justify-content: center; gap: .6rem; }
        .drop-zone:hover, .drop-zone.drag-over { border-color: var(--accent); background: rgba(59,130,246,.04); }
        .drop-zone input[type="file"] { position: absolute; inset: 0; width: 100%; height: 100%; opacity: 0; cursor: pointer; border: none; padding: 0; }
        .drop-zone input[type="file"]:focus { box-shadow: none; }

        /* SCAN ANIMATION */
        .scan-anim { width: 56px; height: 56px; position: relative; margin-bottom: .25rem; }
        .scan-frame { width: 56px; height: 56px; border-radius: 10px; border: 2px solid rgba(59,130,246,.3); position: relative; overflow: hidden; }
        .scan-line { position: absolute; left: 0; right: 0; height: 2px; background: linear-gradient(90deg, transparent, var(--accent), transparent); animation: scan 2s ease-in-out infinite; }
        .scan-corners::before, .scan-corners::after { content: ''; position: absolute; width: 12px; height: 12px; border-color: var(--accent); border-style: solid; }
        .scan-corners::before { top: 4px; left: 4px; border-width: 2px 0 0 2px; border-radius: 2px 0 0 0; }
        .scan-corners::after  { bottom: 4px; right: 4px; border-width: 0 2px 2px 0; border-radius: 0 0 2px 2px; }
        @keyframes scan { 0% { top: 0; opacity: 0; } 10% { opacity: 1; } 50% { top: calc(100% - 2px); } 90% { opacity: 1; } 100% { top: 0; opacity: 0; } }

        .drop-zone-title { font-weight: 600; font-size: .9rem; color: var(--text); }
        .drop-zone-sub   { font-size: .78rem; color: var(--muted); line-height: 1.5; }
        .drop-zone-formats { display: flex; gap: .4rem; flex-wrap: wrap; justify-content: center; margin-top: .3rem; }
        .fmt-pill { font-size: .65rem; font-weight: 600; letter-spacing: .04em; text-transform: uppercase; background: rgba(59,130,246,.1); color: var(--accent); padding: .2rem .55rem; border-radius: 4px; }

        /* PREVIEW GRID */
        .preview-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: .5rem; margin: 0 1.25rem 1rem; }
        .preview-thumb { aspect-ratio: 1; border-radius: 8px; overflow: hidden; position: relative; border: 1px solid var(--border); background: var(--bg); }
        .preview-thumb img { width: 100%; height: 100%; object-fit: cover; display: block; }
        .preview-thumb .remove-btn { position: absolute; top: 4px; right: 4px; width: 20px; height: 20px; border-radius: 50%; background: rgba(239,68,68,.85); color: #fff; border: none; cursor: pointer; font-size: 12px; line-height: 1; display: flex; align-items: center; justify-content: center; opacity: 0; transition: opacity .2s; }
        .preview-thumb:hover .remove-btn { opacity: 1; }
        .preview-thumb.add-more { border-style: dashed; cursor: pointer; display: flex; align-items: center; justify-content: center; color: var(--muted); font-size: 22px; transition: all .2s; }
        .preview-thumb.add-more:hover { border-color: var(--accent); color: var(--accent); }

        /* TIPS */
        .upload-tips { margin: 0 1.25rem 1.25rem; background: rgba(245,158,11,.06); border: 1px solid rgba(245,158,11,.15); border-radius: 9px; padding: .85rem 1rem; }
        .upload-tips-title { font-size: .72rem; font-weight: 600; letter-spacing: .06em; text-transform: uppercase; color: var(--warning); display: flex; align-items: center; gap: .4rem; margin-bottom: .6rem; }
        .upload-tips-title svg { width: 13px; height: 13px; }
        .tip-item { display: flex; align-items: flex-start; gap: .5rem; font-size: .78rem; color: var(--muted); line-height: 1.5; margin-bottom: .35rem; }
        .tip-item:last-child { margin-bottom: 0; }
        .tip-dot { width: 4px; height: 4px; border-radius: 50%; background: var(--warning); flex-shrink: 0; margin-top: 7px; }

        /* COUNT BAR */
        .photo-count { display: flex; align-items: center; justify-content: space-between; margin: 0 1.25rem .75rem; font-size: .78rem; color: var(--muted); }
        .count-bar   { flex: 1; height: 3px; background: var(--border); border-radius: 2px; margin: 0 .75rem; overflow: hidden; }
        .count-fill  { height: 100%; border-radius: 2px; background: linear-gradient(90deg, var(--accent), var(--accent2)); transition: width .3s ease; }

        /* ANIMATION */
        @keyframes fadeUp { from { opacity: 0; transform: translateY(14px); } to { opacity: 1; transform: translateY(0); } }

        /* RESPONSIVE */
        @media (max-width: 720px) { .main { grid-template-columns: 1fr; } .upload-panel { position: static; } .type-toggle { grid-template-columns: 1fr; } }
        @media (max-width: 480px) { .form-row { grid-template-columns: 1fr; } .main { padding: 1.25rem; } }
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
    <div class="nav-right">
        <a href="index.jsp"      class="nav-link">Home</a>
        <a href="searchItem.jsp" class="nav-link">Browse Items</a>
        <% if (session != null && session.getAttribute("loggedUser") != null) { %>
            <span style="color:var(--success);font-size:.875rem;font-weight:500">
                Hi, <%= session.getAttribute("userName") %> &#128075;
            </span>
            <a href="LogoutServlet" class="nav-link" style="color:var(--danger)">Logout</a>
        <% } else { %>
            <a href="login.jsp" class="nav-link" style="color:var(--accent)">Login →</a>
        <% } %>
    </div>
</nav>

<!-- PAGE HEADER -->
<div class="page-header">
    <div class="header-inner">
        <div class="header-icon lost" id="headerIcon">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/>
            </svg>
        </div>
        <div class="header-text">
            <h1 id="headerTitle">Report a Lost Item</h1>
            <p  id="headerSub">Describe your item in detail — the more info you provide, the faster it gets found.</p>
        </div>
    </div>
</div>

<!-- TYPE TOGGLE -->
<div class="type-toggle">
    <button class="type-btn active-lost" onclick="setType('lost')" id="lostBtn" type="button">
        <div class="type-btn-icon">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/>
            </svg>
        </div>
        <div>
            <span class="type-btn-label">I Lost Something</span>
            <span class="type-btn-sub">Report a missing item</span>
        </div>
    </button>
    <button class="type-btn" onclick="setType('found')" id="foundBtn" type="button">
        <div class="type-btn-icon">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/>
            </svg>
        </div>
        <div>
            <span class="type-btn-label">I Found Something</span>
            <span class="type-btn-sub">Help someone reclaim it</span>
        </div>
    </button>
</div>

<!-- MAIN -->
<div class="main">

    <!-- LEFT: FORM -->
    <div class="form-card">

        <%-- Alerts --%>
        <% String error = (String) request.getAttribute("error");
           if (error != null) { %>
            <div class="alert alert-error">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
                <%= error %>
            </div>
        <% } %>

        <% String success = (String) request.getAttribute("success");
           if (success != null) { %>
            <div class="alert alert-success">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>
                <%= success %>
            </div>
        <% } %>

        <form action="PostItemServlet" method="post" enctype="multipart/form-data" id="itemForm">

            <input type="hidden" name="type" id="typeField" value="lost">

            <!-- ITEM DETAILS -->
            <div class="section-label">Item Details</div>

            <div class="form-group">
                <label class="field-label">Item Name</label>
                <input type="text" name="itemName" placeholder="e.g. Black Nike Backpack, iPhone 14, Wallet..." required>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label class="field-label">Category</label>
                    <select name="category" required>
                        <option value="" disabled selected>Select category...</option>
                        <option value="Electronics">Electronics</option>
                        <option value="Bags">Bags &amp; Backpacks</option>
                        <option value="Keys">Keys</option>
                        <option value="Documents">Documents &amp; Cards</option>
                        <option value="Clothing">Clothing</option>
                        <option value="Books">Books &amp; Notebooks</option>
                        <option value="Accessories">Accessories</option>
                        <option value="Sports">Sports Equipment</option>
                        <option value="Other">Other</option>
                    </select>
                </div>
                <div class="form-group">
                    <label class="field-label">Location</label>
                    <select name="location" required>
                        <option value="" disabled selected>Where?</option>
                        <option value="Library">Library</option>
                        <option value="Canteen">Canteen</option>
                        <option value="Block A">Block A</option>
                        <option value="Block B">Block B</option>
                        <option value="Block C">Block C</option>
                        <option value="Block D">Block D</option>
                        <option value="Hostel">Hostel</option>
                        <option value="Playground">Playground</option>
                        <option value="Parking">Parking Area</option>
                        <option value="Auditorium">Auditorium</option>
                        <option value="Labs">Labs</option>
                        <option value="Other">Other</option>
                    </select>
                </div>
            </div>

            <div class="form-group">
                <label class="field-label">Date</label>
                <input type="date" name="datePost" id="dateInput" required>
            </div>

            <!-- DESCRIPTION -->
            <div class="section-label">Description</div>

            <div class="form-group">
                <label class="field-label">Describe the Item</label>
                <textarea name="description"
                    placeholder="Color, brand, size, any unique marks, scratches, stickers, what was inside...&#10;The more detail, the better your chances!"
                    required></textarea>
            </div>

            <!-- hidden file synced from upload panel -->
            <input type="file" name="itemImage" id="hiddenFile" accept="image/*" multiple style="display:none">

            <!-- SUBMIT -->
            <button type="submit" class="btn-submit lost-btn" id="submitBtn">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <line x1="22" y1="2" x2="11" y2="13"/><polygon points="22 2 15 22 11 13 2 9 22 2"/>
                </svg>
                <span id="submitText">Submit Lost Report</span>
            </button>

        </form>
    </div>

    <!-- RIGHT: IMAGE UPLOAD PANEL -->
    <div class="upload-panel">

        <div class="upload-panel-header">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <rect x="3" y="3" width="18" height="18" rx="2" ry="2"/>
                <circle cx="8.5" cy="8.5" r="1.5"/>
                <polyline points="21 15 16 10 5 21"/>
            </svg>
            <span>Photo Evidence</span>
            <span class="tip-badge">Recommended</span>
        </div>

        <!-- Drop Zone -->
        <div class="drop-zone" id="dropZone">
            <input type="file" id="fileInput" accept="image/jpeg,image/png,image/webp,image/gif"
                   multiple onchange="handleFiles(this.files)">
            <div class="scan-anim">
                <div class="scan-frame scan-corners">
                    <div class="scan-line"></div>
                </div>
            </div>
            <div class="drop-zone-title">Drop photos here</div>
            <div class="drop-zone-sub">or click anywhere to browse</div>
            <div class="drop-zone-formats">
                <span class="fmt-pill">JPG</span>
                <span class="fmt-pill">PNG</span>
                <span class="fmt-pill">WEBP</span>
                <span class="fmt-pill">GIF</span>
            </div>
        </div>

        <!-- Count Bar -->
        <div class="photo-count" id="photoCount" style="display:none">
            <span id="countText">0 / 4 photos</span>
            <div class="count-bar">
                <div class="count-fill" id="countFill" style="width:0%"></div>
            </div>
            <span id="countPct" style="color:var(--accent);font-weight:600">0%</span>
        </div>

        <!-- Preview Grid -->
        <div class="preview-grid" id="previewGrid" style="display:none"></div>

        <!-- Tips -->
        <div class="upload-tips">
            <div class="upload-tips-title">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/>
                </svg>
                Photo Tips
            </div>
            <div class="tip-item"><div class="tip-dot"></div><span>Clear, well-lit photos increase recovery chances by 3x</span></div>
            <div class="tip-item"><div class="tip-dot"></div><span>Show unique marks, stickers, or brand logos</span></div>
            <div class="tip-item"><div class="tip-dot"></div><span>Multiple angles help owners verify their item</span></div>
            <div class="tip-item"><div class="tip-dot"></div><span>Max 4 photos &middot; 5MB each</span></div>
        </div>

    </div>
</div>

<script>
    // ── TYPE TOGGLE ──────────────────────────────
    let currentType = 'lost';

    function setType(type) {
        currentType = type;
        document.getElementById('typeField').value = type;

        const lostBtn     = document.getElementById('lostBtn');
        const foundBtn    = document.getElementById('foundBtn');
        const submitBtn   = document.getElementById('submitBtn');
        const submitText  = document.getElementById('submitText');
        const headerIcon  = document.getElementById('headerIcon');
        const headerTitle = document.getElementById('headerTitle');
        const headerSub   = document.getElementById('headerSub');

        if (type === 'lost') {
            lostBtn.className   = 'type-btn active-lost';
            foundBtn.className  = 'type-btn';
            submitBtn.className = 'btn-submit lost-btn';
            submitText.textContent  = 'Submit Lost Report';
            headerIcon.className    = 'header-icon lost';
            headerTitle.textContent = 'Report a Lost Item';
            headerSub.textContent   = 'Describe your item in detail — the more info you provide, the faster it gets found.';
        } else {
            foundBtn.className  = 'type-btn active-found';
            lostBtn.className   = 'type-btn';
            submitBtn.className = 'btn-submit found-btn';
            submitText.textContent  = 'Submit Found Report';
            headerIcon.className    = 'header-icon found';
            headerTitle.textContent = 'Report a Found Item';
            headerSub.textContent   = 'Help someone reclaim their belonging. Describe what you found and where.';
        }
    }

    // ── AUTO SET TYPE FROM URL PARAM ─────────────
    const urlParams = new URLSearchParams(window.location.search);
    if (urlParams.get('type') === 'found') setType('found');

    // ── SET TODAY AS DEFAULT DATE ─────────────────
    const today = new Date().toISOString().split('T')[0];
    document.getElementById('dateInput').value = today;

    // ── IMAGE UPLOAD ──────────────────────────────
    const MAX_PHOTOS  = 4;
    let uploadedFiles = [];

    const dropZone    = document.getElementById('dropZone');
    const previewGrid = document.getElementById('previewGrid');
    const photoCount  = document.getElementById('photoCount');

    dropZone.addEventListener('dragover', e => { e.preventDefault(); dropZone.classList.add('drag-over'); });
    dropZone.addEventListener('dragleave', ()  => dropZone.classList.remove('drag-over'));
    dropZone.addEventListener('drop', e => {
        e.preventDefault();
        dropZone.classList.remove('drag-over');
        handleFiles(e.dataTransfer.files);
    });

    function handleFiles(files) {
        const remaining = MAX_PHOTOS - uploadedFiles.length;
        const toAdd = Math.min(files.length, remaining);
        for (let i = 0; i < toAdd; i++) {
            const file = files[i];
            if (!file.type.startsWith('image/')) continue;
            if (file.size > 5 * 1024 * 1024) { alert(file.name + ' exceeds 5MB limit.'); continue; }
            uploadedFiles.push(file);
        }
        renderPreviews();
        updateCount();
        syncHiddenInput();
    }

    function renderPreviews() {
        previewGrid.innerHTML = '';
        if (uploadedFiles.length === 0) {
            previewGrid.style.display = 'none';
            photoCount.style.display  = 'none';
            dropZone.style.display    = 'flex';
            return;
        }
        previewGrid.style.display = 'grid';
        photoCount.style.display  = 'flex';
        dropZone.style.display    = uploadedFiles.length >= MAX_PHOTOS ? 'none' : 'flex';

        uploadedFiles.forEach((file, idx) => {
            const reader = new FileReader();
            reader.onload = e => {
                const thumb = document.createElement('div');
                thumb.className = 'preview-thumb';
                thumb.innerHTML = `
                    <img src="${e.target.result}" alt="Photo ${idx+1}">
                    <button class="remove-btn" onclick="removePhoto(${idx})" type="button">&times;</button>
                `;
                previewGrid.appendChild(thumb);
            };
            reader.readAsDataURL(file);
        });

        if (uploadedFiles.length < MAX_PHOTOS) {
            const addMore = document.createElement('div');
            addMore.className = 'preview-thumb add-more';
            addMore.textContent = '+';
            addMore.onclick = () => document.getElementById('fileInput').click();
            previewGrid.appendChild(addMore);
        }
    }

    function removePhoto(idx) {
        uploadedFiles.splice(idx, 1);
        renderPreviews();
        updateCount();
        syncHiddenInput();
    }

    function updateCount() {
        const count = uploadedFiles.length;
        const pct   = Math.round((count / MAX_PHOTOS) * 100);
        document.getElementById('countText').textContent = `${count} / ${MAX_PHOTOS} photos`;
        document.getElementById('countFill').style.width = pct + '%';
        document.getElementById('countPct').textContent  = pct + '%';
    }

    function syncHiddenInput() {
        const dt = new DataTransfer();
        uploadedFiles.forEach(f => dt.items.add(f));
        document.getElementById('hiddenFile').files = dt.files;
    }
</script>

</body>
</html>
