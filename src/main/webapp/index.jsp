<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Головна | VotingSystem</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; }
        .hero-section {
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
            color: white;
            padding: 80px 0;
            margin-bottom: 40px;
        }
        .search-container {
            max-width: 600px;
            margin: -30px auto 0;
            position: relative;
            z-index: 10;
        }
        .search-input {
            border-radius: 50px;
            padding: 15px 25px;
            border: none;
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
        }
        .voting-card {
            border: none;
            border-radius: 20px;
            transition: 0.3s;
            overflow: hidden;
        }
        .voting-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 30px rgba(0,0,0,0.1);
        }
        .navbar { background-color: #1a1a1a; }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-dark">
    <div class="container">
        <a class="navbar-brand fw-bold" href="index">🗳️ VotingSystem</a>
        <div class="ms-auto d-flex align-items-center">
            <c:choose>
                <c:when test="${empty sessionScope.user}">
                    <a href="login.jsp" class="btn btn-outline-light btn-sm me-2">Увійти</a>
                    <a href="register.jsp" class="btn btn-primary btn-sm">Реєстрація</a>
                </c:when>
                <c:otherwise>
                    <span class="text-white me-3 small">Привіт, <strong class="text-info">${sessionScope.user.username}</strong></span>
                    <a href="my-votings" class="btn btn-outline-info btn-sm me-2">📁 Мої голосування</a>
                    <a href="auth?action=logout" class="btn btn-outline-danger btn-sm">Вийти</a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</nav>
<c:if test="${param.error == 'already_voted'}">
    <div class="container mt-3">
        <div class="alert alert-warning alert-dismissible fade show" role="alert">
            <strong>Увага!</strong> Ви вже брали участь у цьому голосуванні. Повторне голосування неможливе.
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </div>
</c:if>
<div class="hero-section text-center">
    <div class="container">
        <h1 class="display-3 fw-bold mb-3">Знайдіть своє голосування</h1>
        <p class="lead opacity-75 mb-4">Відкриті опитування для кожного. Ваш голос формує результат.</p>
        <a href="create-voting.jsp" class="btn btn-warning btn-lg px-5 fw-bold rounded-pill shadow">
            ➕ Створити власне голосування
        </a>
    </div>
</div>

<div class="container">
    <div class="search-container mb-5">
        <form action="main" method="get">
            <div class="input-group">
                <input type="text" name="query" class="form-control search-input"
                       placeholder="Введіть назву для пошуку..." value="${param.query}">
                <button class="btn btn-dark rounded-pill px-4 ms-2" type="submit">Шукати</button>
            </div>
        </form>
    </div>

    <div class="row">
        <c:forEach var="v" items="${votings}">
            <div class="col-md-4 mb-4">
                <div class="card h-100 voting-card shadow-sm">
                    <div class="card-body p-4 d-flex flex-column">
                        <div class="mb-3">
                            <c:choose>
                                <c:when test="${v.active}">
                                    <span class="badge bg-success">Активне</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-secondary">Завершене</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <h4 class="fw-bold mb-2">${v.title}</h4>
                        <p class="text-muted small mb-4">Автор: @${v.hostId}</p>

                        <div class="mt-auto">
                            <div class="d-grid gap-2">
                                <c:if test="${v.active}">
                                    <a href="vote?id=${v.id}" class="btn btn-primary py-2 fw-bold">Проголосувати</a>
                                </c:if>
                                <a href="results?id=${v.id}" class="btn btn-outline-dark py-2">Результати</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </c:forEach>

        <%-- Якщо список порожній --%>
        <c:if test="${empty votings}">
            <div class="alert alert-info text-center mt-5">
                <h4 class="alert-heading">🔍 Голосувань не знайдено</h4>
                <p>Спробуйте змінити запит або створіть власне голосування!</p>
            </div>
        </c:if>

        <%-- Твій існуючий список (він з'явиться, тільки якщо votings не порожній) --%>
        <div class="row">
            <c:forEach var="v" items="${votings}">
                <div class="col-md-4 mb-4">
                    </div>
            </c:forEach>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>