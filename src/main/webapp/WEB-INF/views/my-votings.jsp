<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Мої голосування</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <nav class="navbar navbar-dark bg-dark mb-4">
        <div class="container">
            <a class="navbar-brand" href="/index">🗳️ VotingSystem</a>
            <a href="/index" class="btn btn-outline-light btn-sm">На головну</a>
        </div>
    </nav>

    <div class="container">
        <h2 class="mb-4 text-center">Ваші створені голосування</h2>

        <div class="row">
            <c:choose>
                <c:when test="${empty myVotings}">
                    <div class="col-12 text-center">
                        <p class="text-muted">Ви ще не створили жодного голосування.</p>
                        <a href="create-voting.jsp" class="btn btn-primary">Створити зараз</a>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="v" items="${myVotings}">
                        <div class="col-md-6 mb-3">
                            <div class="card shadow-sm">
                                <div class="card-body">
                                    <h5 class="card-title">${v.title}</h5>
                                    <p>Статус:
                                        <c:choose>
                                            <c:when test="${v.active}"><span class="badge bg-success">Активне</span></c:when>
                                            <c:otherwise><span class="badge bg-danger">Зупинено</span></c:otherwise>
                                        </c:choose>
                                    </p>
                                    <div class="d-flex gap-2">
                                        <a href="results?id=${v.id}" class="btn btn-info btn-sm text-white">Керувати/Результати</a>
                                        <a href="vote?id=${v.id}" class="btn btn-outline-primary btn-sm">Сторінка вибору</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</body>
</html>