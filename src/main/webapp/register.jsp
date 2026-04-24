<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register — CampusLostFound</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@300;400;500;600&family=Playfair+Display:wght@700&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        :root {
            --bg:      #0b0f1a;
            --surface: #131929;
            --border:  #1e2d45;
            --accent:  #3b82f6;
            --text:    #e2e8f0;
            --muted:   #64748b;
            --danger:  #ef4444;
            --success: #22c55e;
            --radius:  12px;
        }

        body {
            font-family: 'DM Sans', sans-serif;
            background: var(--bg);
            color: var(--text);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        /* ── NAV ── */
        nav {
            position: sticky; top: 0; z-index: 100;
            background: rgba(11,15,26,.85);
            backdrop-filter: blur(16px);
            border-bottom: 1px solid var(--border);
            padding: 0 2rem;
            display: flex; align-items: center; justify-content: space-between;
            height: 64px;
        }
        .nav-brand {
            display: flex; align-items: center; gap: .6rem;
            text-decoration: none; color: var(--text);
        }
        .nav-brand span { font-weight: 600; font-size: 1.05rem; }

        /* ── PAGE LAYOUT ── */
        .page-wrap {
            flex: 1;
            display: flex; align-items: center; justify-content: center;
            padding: 3rem 1rem;
            position: relative;
        }
        .page-wrap::before {
            content: ''; position: absolute; inset: 0;
            background: radial-gradient(ellipse 60% 40% at 50% 0%,
                rgba(59,130,246,.12) 0%, transparent 70%);
            pointer-events: none;
        }

        /* ── CARD ── */
        .card {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 18px;
            padding: 2.5rem 2.25rem;
            width: 100%; max-width: 500px;
            animation: fadeUp .5s ease both;
        }
        .card-icon {
            width: 52px; height: 52px; border-radius: 14px;
            background: rgba(59,130,246,.12);
            border: 1px solid rgba(59,130,246,.2);
            display: flex; align-items: center; justify-content: center;
            color: var(--accent); margin-bottom: 1.25rem;
        }
        .card-icon svg { width: 24px; height: 24px; }
        .card h1 {
            font-family: 'Playfair Display', serif;
            font-size: 1.75rem; margin-bottom: .4rem;
        }
        .card > p {
            color: var(--muted); font-size: .9rem;
            margin-bottom: 1.75rem; line-height: 1.6;
        }

        /* ── ALERTS ── */
        .alert {
            border-radius: 9px; padding: .75rem 1rem;
            font-size: .875rem; margin-bottom: 1.25rem;
            display: flex; align-items: center; gap: .5rem;
        }
        .alert svg { width: 16px; height: 16px; flex-shrink: 0; }
        .alert-error {
            background: rgba(239,68,68,.1);
            border: 1px solid rgba(239,68,68,.3);
            color: var(--danger);
        }
        .alert-success {
            background: rgba(34,197,94,.1);
            border: 1px solid rgba(34,197,94,.3);
            color: var(--success);
        }

        /* ── FORM ── */
        .form-row {
            display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;
        }
        .form-group { margin-bottom: 1.1rem; }

        label {
            display: block;
            font-size: .78rem; font-weight: 600;
            letter-spacing: .07em; text-transform: uppercase;
            color: var(--muted); margin-bottom: .5rem;
        }

        input, select {
            width: 100%;
            background: var(--bg);
            border: 1px solid var(--border);
            border-radius: 9px;
            padding: .75rem 1rem;
            color: var(--text);
            font-family: 'DM Sans', sans-serif;
            font-size: .9rem;
            transition: border .2s, box-shadow .2s;
            outline: none;
            appearance: none;
        }
        input:focus, select:focus {
            border-color: var(--accent);
            box-shadow: 0 0 0 3px rgba(59,130,246,.15);
        }
        input::placeholder { color: var(--muted); }

        select option { background: #131929; color: var(--text); }

        /* ── DIVIDER ── */
        .section-divider {
            font-size: .72rem; font-weight: 600;
            letter-spacing: .1em; text-transform: uppercase;
            color: var(--muted);
            display: flex; align-items: center; gap: .75rem;
            margin: 1.25rem 0 1.1rem;
        }
        .section-divider::before, .section-divider::after {
            content: ''; flex: 1; height: 1px; background: var(--border);
        }

        /* ── SUBMIT ── */
        .btn-submit {
            width: 100%;
            background: var(--accent); color: #fff;
            border: none; border-radius: 9px;
            padding: .85rem;
            font-family: 'DM Sans', sans-serif;
            font-size: .95rem; font-weight: 600;
            cursor: pointer;
            transition: background .2s, transform .2s, box-shadow .2s;
            display: flex; align-items: center;
            justify-content: center; gap: .5rem;
            margin-top: .5rem;
        }
        .btn-submit:hover {
            background: #2563eb;
            transform: translateY(-1px);
            box-shadow: 0 6px 20px rgba(59,130,246,.35);
        }
        .btn-submit svg { width: 17px; height: 17px; }

        /* ── FOOTER LINK ── */
        .login-link {
            display: block; text-align: center;
            font-size: .875rem; color: var(--muted);
            text-decoration: none; margin-top: 1.25rem;
        }
        .login-link span { color: var(--accent); font-weight: 500; }
        .login-link:hover span { text-decoration: underline; }

        /* ── ANIMATION ── */
        @keyframes fadeUp {
            from { opacity: 0; transform: translateY(16px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        @media (max-width: 480px) {
            .form-row { grid-template-columns: 1fr; }
            .card { padding: 2rem 1.5rem; }
        }
    </style>
</head>
<body>

<!-- NAV -->
<nav>
    <a href="index.jsp" class="nav-brand">
        <svg width="22" height="22" viewBox="0 0 24 24" fill="none"
             stroke="#3b82f6" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/>
            <circle cx="12" cy="10" r="3"/>
        </svg>
        <span>CampusLostFound</span>
    </a>
    <a href="login.jsp"
       style="color:var(--accent);font-size:.875rem;text-decoration:none;font-weight:500">
        Already registered? Login →
    </a>
</nav>

<!-- PAGE -->
<div class="page-wrap">
    <div class="card">

        <div class="card-icon">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
                 stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/>
                <circle cx="9" cy="7" r="4"/>
                <line x1="19" y1="8" x2="19" y2="14"/>
                <line x1="22" y1="11" x2="16" y2="11"/>
            </svg>
        </div>

        <h1>Create Account</h1>
        <p>Join the campus lost &amp; found network. Report, search, and reclaim items easily.</p>

        <%-- Error Message --%>
        <% String error = (String) request.getAttribute("error");
           if (error != null) { %>
            <div class="alert alert-error">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
                     stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <circle cx="12" cy="12" r="10"/>
                    <line x1="12" y1="8" x2="12" y2="12"/>
                    <line x1="12" y1="16" x2="12.01" y2="16"/>
                </svg>
                <%= error %>
            </div>
        <% } %>

        <%-- Success Message --%>
        <% String success = (String) request.getAttribute("success");
           if (success != null) { %>
            <div class="alert alert-success">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
                     stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/>
                    <polyline points="22 4 12 14.01 9 11.01"/>
                </svg>
                <%= success %>
            </div>
        <% } %>

        <form action="RegisterServlet" method="post">

            <!-- Personal Info -->
            <div class="section-divider">Personal Info</div>

            <div class="form-group">
                <label>Full Name</label>
                <input type="text" name="name" placeholder="e.g. Raj Kumar" required>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label>Roll Number</label>
                    <input type="text" name="rollNumber" placeholder="e.g. 21CS001" required>
                </div>
                <div class="form-group">
                    <label>Department</label>
                    <select name="department" required>
                        <option value="" disabled selected>Select dept...</option>
                        <option value="CSE">CSE</option>
                        <option value="ECE">ECE</option>
                        <option value="MECH">MECH</option>
                        <option value="CIVIL">CIVIL</option>
                        <option value="IT">IT</option>
                        <option value="EEE">EEE</option>
                        <option value="AIDS">AIDS</option>
                        <option value="Other">Other</option>
                    </select>
                </div>
            </div>

            <div class="form-group">
                <label>Contact Number</label>
                <input type="tel" name="contact"
                       placeholder="10-digit mobile number"
                       maxlength="10" required>
            </div>

            <!-- Account Info -->
            <div class="section-divider">Account Info</div>

            <div class="form-row">
                <div class="form-group">
                    <label>Password</label>
                    <input type="password" name="password"
                           placeholder="Create password" required>
                </div>
                <div class="form-group">
                    <label>Confirm Password</label>
                    <input type="password" name="confirmPassword"
                           placeholder="Repeat password" required>
                </div>
            </div>

            <button type="submit" class="btn-submit">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
                     stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/>
                    <circle cx="9" cy="7" r="4"/>
                    <line x1="19" y1="8" x2="19" y2="14"/>
                    <line x1="22" y1="11" x2="16" y2="11"/>
                </svg>
                Create My Account
            </button>
        </form>

        <a href="login.jsp" class="login-link">
            Already have an account? <span>Login here</span>
        </a>
    </div>
</div>

</body>
</html>