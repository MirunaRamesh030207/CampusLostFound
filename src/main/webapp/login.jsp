<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login — CampusLostFound</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@300;400;500;600&family=Playfair+Display:wght@700&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        :root {
            --bg: #0b0f1a; --surface: #131929; --border: #1e2d45;
            --accent: #3b82f6; --text: #e2e8f0; --muted: #64748b;
            --danger: #ef4444; --success: #22c55e; --radius: 12px;
        }
        body { font-family: 'DM Sans', sans-serif; background: var(--bg); color: var(--text); min-height: 100vh; display: flex; flex-direction: column; }

        nav {
            position: sticky; top: 0; z-index: 100;
            background: rgba(11,15,26,.85); backdrop-filter: blur(16px);
            border-bottom: 1px solid var(--border);
            padding: 0 2rem; display: flex; align-items: center;
            justify-content: space-between; height: 64px;
        }
        .nav-brand { display: flex; align-items: center; gap: .6rem; text-decoration: none; color: var(--text); }
        .nav-brand span { font-weight: 600; font-size: 1.05rem; }

        .page-wrap {
            flex: 1; display: flex; align-items: center;
            justify-content: center; padding: 3rem 1rem;
            position: relative;
        }
        .page-wrap::before {
            content: ''; position: absolute; inset: 0;
            background: radial-gradient(ellipse 60% 40% at 50% 0%, rgba(59,130,246,.12) 0%, transparent 70%);
            pointer-events: none;
        }

        .card {
            background: var(--surface); border: 1px solid var(--border);
            border-radius: 18px; padding: 2.5rem 2.25rem;
            width: 100%; max-width: 420px;
            animation: fadeUp .5s ease both;
        }
        .card-icon {
            width: 52px; height: 52px; border-radius: 14px;
            background: rgba(59,130,246,.12); border: 1px solid rgba(59,130,246,.2);
            display: flex; align-items: center; justify-content: center;
            color: var(--accent); margin-bottom: 1.25rem;
        }
        .card-icon svg { width: 24px; height: 24px; }
        .card h1 { font-family: 'Playfair Display', serif; font-size: 1.75rem; margin-bottom: .4rem; }
        .card p { color: var(--muted); font-size: .9rem; margin-bottom: 1.75rem; line-height: 1.6; }

        .form-group { margin-bottom: 1.1rem; }
        label { display: block; font-size: .78rem; font-weight: 600;
                letter-spacing: .07em; text-transform: uppercase;
                color: var(--muted); margin-bottom: .5rem; }
        input {
            width: 100%; background: var(--bg); border: 1px solid var(--border);
            border-radius: 9px; padding: .75rem 1rem; color: var(--text);
            font-family: 'DM Sans', sans-serif; font-size: .9rem;
            transition: border .2s, box-shadow .2s; outline: none;
        }
        input:focus { border-color: var(--accent); box-shadow: 0 0 0 3px rgba(59,130,246,.15); }
        input::placeholder { color: var(--muted); }

        .error-box {
            background: rgba(239,68,68,.1); border: 1px solid rgba(239,68,68,.3);
            color: var(--danger); border-radius: 9px; padding: .75rem 1rem;
            font-size: .875rem; margin-bottom: 1.25rem;
            display: flex; align-items: center; gap: .5rem;
        }
        .error-box svg { width: 16px; height: 16px; flex-shrink: 0; }

        .btn-submit {
            width: 100%; background: var(--accent); color: #fff;
            border: none; border-radius: 9px; padding: .85rem;
            font-family: 'DM Sans', sans-serif; font-size: .95rem; font-weight: 600;
            cursor: pointer; transition: background .2s, transform .2s;
            display: flex; align-items: center; justify-content: center; gap: .5rem;
            margin-top: .5rem;
        }
        .btn-submit:hover { background: #2563eb; transform: translateY(-1px); }
        .btn-submit svg { width: 17px; height: 17px; }

        .divider { text-align: center; color: var(--muted); font-size: .82rem; margin: 1.25rem 0; position: relative; }
        .divider::before, .divider::after {
            content: ''; position: absolute; top: 50%; width: 42%; height: 1px;
            background: var(--border);
        }
        .divider::before { left: 0; } .divider::after { right: 0; }

        .register-link {
            display: block; text-align: center; font-size: .875rem;
            color: var(--muted); text-decoration: none;
        }
        .register-link span { color: var(--accent); font-weight: 500; }
        .register-link:hover span { text-decoration: underline; }

        @keyframes fadeUp {
            from { opacity: 0; transform: translateY(16px); }
            to   { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body>

<nav>
    <a href="index.jsp" class="nav-brand">
        <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="#3b82f6"
             stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/>
            <circle cx="12" cy="10" r="3"/>
        </svg>
        <span>CampusLostFound</span>
    </a>
    <a href="register.jsp" style="color:var(--accent);font-size:.875rem;text-decoration:none;font-weight:500">
        Create Account →
    </a>
</nav>

<div class="page-wrap">
    <div class="card">
        <div class="card-icon">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                 stroke-linecap="round" stroke-linejoin="round">
                <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
                <circle cx="12" cy="7" r="4"/>
            </svg>
        </div>
        <h1>Welcome Back</h1>
        <p>Login to report lost items, claim found ones, and stay connected to your campus community.</p>

        <%-- Show error if login failed --%>
        <% String error = (String) request.getAttribute("error");
           if (error != null) { %>
            <div class="error-box">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                     stroke-linecap="round" stroke-linejoin="round">
                    <circle cx="12" cy="12" r="10"/>
                    <line x1="12" y1="8" x2="12" y2="12"/>
                    <line x1="12" y1="16" x2="12.01" y2="16"/>
                </svg>
                <%= error %>
            </div>
        <% } %>

        <form action="LoginServlet" method="post">
            <div class="form-group">
                <label>Roll Number</label>
                <input type="text" name="rollNumber" placeholder="e.g. 21CS001" required>
            </div>
            <div class="form-group">
                <label>Password</label>
                <input type="password" name="password" placeholder="Your password" required>
            </div>
            <button type="submit" class="btn-submit">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                     stroke-linecap="round" stroke-linejoin="round">
                    <path d="M15 3h4a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-4"/>
                    <polyline points="10 17 15 12 10 7"/>
                    <line x1="15" y1="12" x2="3" y2="12"/>
                </svg>
                Login to Portal
            </button>
        </form>

        <div class="divider">or</div>
        <a href="register.jsp" class="register-link">
            Don't have an account? <span>Register here</span>
        </a>
    </div>
</div>

</body>
</html>