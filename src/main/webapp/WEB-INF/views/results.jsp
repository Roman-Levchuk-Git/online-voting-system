<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<html>
<head>
    <title>Результати | ${voting.title}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f4f7f6; }
        .card { border-radius: 15px; overflow: hidden; }
        .progress { height: 25px; border-radius: 12px; }
    </style>
</head>
<body>

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="card shadow-lg border-0">

                <div class="card-header bg-primary text-white p-4 text-center">
                    <h2 class="mb-2">${voting.title}</h2>
                    <c:choose>
                        <c:when test="${voting.active}">
                            <span class="badge bg-success p-2">🔓 Голосування активне</span>
                        </c:when>
                        <c:otherwise>
                            <span class="badge bg-danger p-2">🔒 Голосування зупинено</span>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="card-body p-4">


                    <c:if test="${sessionScope.user.username == voting.hostId}">
                        <div class="alert alert-warning border-0 shadow-sm mb-4 text-center">
                            <h6 class="fw-bold mb-3">Панель керування хазяїна</h6>
                            <div class="d-grid gap-2">
                                <form action="results?id=${voting.id}" method="post">
                                    <button type="submit" class="btn ${voting.active ? 'btn-danger' : 'btn-success'} w-100 py-2">
                                        ${voting.active ? '⛔ Зупинити' : '✅ Запустити'}
                                    </button>
                                </form>

                                <a href="delete-voting?id=${voting.id}"
                                   class="btn btn-outline-danger w-100"
                                   onclick="return confirm('Ви впевнені, що хочете видалити це голосування назавжди?')">
                                    🗑️ Видалити голосування
                                </a>
                            </div>
                        </div>
                    </c:if>

                    <c:if test="${sessionScope.user.username == voting.hostId}">
                        <div class="mt-5 border-top pt-4">
                            <h3 class="text-primary mb-3">Журнал голосування (бачить тільки автор)</h3>
                            <div class="table-responsive">
                                <table class="table table-hover table-bordered bg-white">
                                    <thead class="table-light">
                                        <tr>
                                            <th>Користувач (ID)</th>
                                            <th>Вибір (Кандидат)</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="vote" items="${detailedVotes}">
                                            <tr>
                                                <td><strong>@${vote.userId}</strong></td>
                                                <td>
                                                    <span class="badge bg-info text-dark">
                                                        ${candidateNames[vote.candidateId]}
                                                    </span>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                        <c:if test="${empty detailedVotes}">
                                            <tr>
                                                <td colspan="2" class="text-center text-muted">Ще ніхто не проголосував</td>
                                            </tr>
                                        </c:if>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </c:if>
                    <div class="text-center mb-4">
                        <h5 class="text-muted">Загальна кількість голосів: <span class="badge bg-dark">${total}</span></h5>
                        <small class="text-muted">(Обчислено паралельно через ForkJoin)</small>
                    </div>

                    <div class="results-list">
                        <c:forEach var="entry" items="${results}">
                            <div class="mb-4">
                                <div class="d-flex justify-content-between mb-1">
                                    <span class="h5 mb-0">${entry.key.name}</span>
                                    <span class="fw-bold text-primary">${entry.value} голос(ів)</span>
                                </div>

                                <%-- Розрахунок відсотків --%>
                                <c:set var="percent" value="${total > 0 ? (entry.value * 100.0 / total) : 0}" />

                                <div class="progress shadow-sm">
                                    <div class="progress-bar progress-bar-striped progress-bar-animated bg-info"
                                         style="width: ${percent}%">
                                        <fmt:formatNumber value="${percent}" maxFractionDigits="0"/>%
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>

                    <div class="mt-5 p-4 bg-light border rounded text-center">
                        <h6 class="text-muted mb-3">Потрібно проголосувати?</h6>
                        <div class="d-grid gap-2">
                            <a href="vote?id=${voting.id}" class="btn btn-outline-primary btn-lg shadow-sm">
                                🚀 Перейти до сторінки вибору
                            </a>
                        </div>
                    </div>

                </div>

                <div class="card-footer bg-white text-center py-3 border-0">
                    <a href="/index" class="btn btn-link text-decoration-none text-secondary">← Повернутися на головну</a>
                </div>

            </div>
        </div>
    </div>
</div>

</body>
</html>