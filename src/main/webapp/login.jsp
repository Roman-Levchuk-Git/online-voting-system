<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Вхід</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light d-flex align-items-center vh-100">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-4">
                <div class="card shadow-lg border-0">
                    <div class="card-body p-5">
                        <h2 class="text-center mb-4">Вхід</h2>
                        <c:if test="${not empty param.error}">
                            <div class="alert alert-danger p-2 small">${param.error}</div>
                        </c:if>
                        <form action="auth?action=login" method="post">
                            <div class="mb-3">
                                <input type="text" name="username" class="form-control" placeholder="Логін" required>
                            </div>
                            <div class="mb-4">
                                <input type="password" name="password" class="form-control" placeholder="Пароль" required>
                            </div>
                            <button type="submit" class="btn btn-primary w-100 py-2">Увійти</button>
                        </form>
                        <div class="text-center mt-3">
                            <a href="register.jsp" class="text-decoration-none">Створити акаунт</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>