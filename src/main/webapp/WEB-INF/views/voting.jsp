<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Голосування | ${voting.title}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f4f7f6; }
        .voting-card { border-radius: 15px; border: none; }
        .option-item { cursor: pointer; transition: 0.2s; border: 2px solid #eee; margin-bottom: 10px; border-radius: 10px !class; }
        .option-item:hover { background-color: #f8f9ff; border-color: #0d6efd; }
        .form-check-input:checked + .h5 { color: #0d6efd; }
    </style>
</head>
<body class="d-flex align-items-center vh-100">

<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-6 col-lg-5">
            <div class="card voting-card shadow-lg">
                <div class="card-body p-4">
                    <h2 class="text-center fw-bold mb-4">${voting.title}</h2>

                    <c:choose>
                        <%-- ЯКЩО ГОЛОСУВАННЯ ЗУПИНЕНО --%>
                        <c:when test="${not voting.active}">
                            <div class="alert alert-danger text-center py-4 shadow-sm">
                                <div class="display-1 mb-3">⛔</div>
                                <h4 class="alert-heading">Голосування закрите</h4>
                                <p class="mb-4">Хазяїн цього опитування зупинив прийом нових голосів.</p>
                                <a href="results?id=${voting.id}" class="btn btn-danger w-100 py-2">
                                    Переглянути фінальні результати
                                </a>
                            </div>
                        </c:when>

                        <%-- ЯКЩО ГОЛОСУВАННЯ АКТИВНЕ --%>
                        <c:otherwise>
                            <p class="text-muted text-center mb-4">Оберіть один із варіантів нижче:</p>

                            <form action="vote" method="post">
                                <input type="hidden" name="votingId" value="${voting.id}">

                                <div class="list-group mb-4">
                                    <c:forEach var="candidate" items="${voting.candidates}">
                                        <label class="list-group-item option-item p-3 shadow-sm">
                                            <div class="form-check d-flex align-items-center">
                                                <input class="form-check-input me-3" type="radio" name="candidateId" value="${candidate.id}" required>
                                                <span class="h5 mb-0">${candidate.name}</span>
                                            </div>
                                        </label>
                                    </c:forEach>
                                </div>

                                <button type="submit" class="btn btn-primary btn-lg w-100 py-3 shadow">
                                    ✅ Підтвердити мій голос
                                </button>
                            </form>
                        </c:otherwise>
                    </c:choose>

                    <div class="text-center mt-4">
                        <a href="/index" class="text-muted text-decoration-none small">← Повернутися на головну</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>