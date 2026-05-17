<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Створити голосування | VotingSystem</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; }
        .create-card { border-radius: 20px; border: none; box-shadow: 0 10px 30px rgba(0,0,0,0.1); }
    </style>
</head>
<body>

<nav class="navbar navbar-dark bg-dark mb-5">
    <div class="container">
        <a class="navbar-brand fw-bold" href="index">🗳️ VotingSystem</a>
        <a href="index" class="btn btn-outline-light btn-sm">Повернутися на головну</a>
    </div>
</nav>

<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-6">
            <div class="card create-card p-4">
                <h2 class="text-center fw-bold mb-4">Нове опитування</h2>

                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <form action="create" method="post">
                            <div class="mb-3">
                                <label class="form-label fw-bold">Тема голосування</label>
                                <input type="text" name="title" class="form-control form-control-lg"
                                       placeholder="Наприклад: Куди підемо на вихідних?" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label fw-bold">Варіанти відповіді (через кому)</label>
                                <textarea name="candidatesList" class="form-control" rows="4"
                                          placeholder="Кіно, Парк, Кафе, Боулінг" required></textarea>
                                <div class="form-text text-muted">Введіть варіанти, розділяючи їх комами.</div>
                            </div>
                            <div class="d-grid mt-4">
                                <button type="submit" class="btn btn-primary btn-lg shadow">🚀 Опублікувати</button>
                            </div>
                        </form>
                    </c:when>
                    <c:otherwise>
                        <div class="alert alert-warning text-center">
                            <h5>Доступ заборонено</h5>
                            <p>Щоб створити голосування, спочатку <a href="login.jsp">увійдіть</a> у систему.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>

</body>
</html>