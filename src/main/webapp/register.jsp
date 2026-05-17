<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Реєстрація | VotingSystem</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; }
        .register-card { border: none; border-radius: 15px; box-shadow: 0 10px 30px rgba(0,0,0,0.1); }
        .btn-register { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); border: none; color: white; }
        .btn-register:hover { opacity: 0.9; color: white; }
    </style>
</head>
<body class="d-flex align-items-center vh-100">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-5 col-lg-4">
                <div class="card register-card">
                    <div class="card-body p-5">
                        <div class="text-center mb-4">
                            <h2 class="fw-bold">Створити акаунт</h2>
                            <p class="text-muted">Приєднуйтесь до нашої системи</p>
                        </div>

                        <%-- Виведення помилки, якщо користувач вже існує --%>
                        <c:if test="${not empty param.error}">
                            <div class="alert alert-danger py-2 small text-center">
                                ${param.error == 'User exists' ? 'Користувач із таким логіном вже є' : param.error}
                            </div>
                        </c:if>

                        <form action="auth?action=register" method="post">
                            <div class="form-floating mb-3">
                                <input type="text" name="username" class="form-control" id="userInput" placeholder="Логін" required>
                                <label for="userInput">Логін</label>
                            </div>
                            <div class="form-floating mb-4">
                                <input type="password" name="password" class="form-control" id="passInput" placeholder="Пароль" required>
                                <label for="passInput">Пароль</label>
                            </div>

                            <button type="submit" class="btn btn-register w-100 py-3 fw-bold shadow-sm">
                                Зареєструватися
                            </button>
                        </form>

                        <div class="text-center mt-4">
                            <span class="text-muted">Вже маєте акаунт?</span>
                            <a href="login.jsp" class="text-decoration-none fw-bold text-primary">Увійти</a>
                        </div>
                    </div>
                </div>
                <div class="text-center mt-3">
                    <a href="index" class="text-muted small text-decoration-none">← На головну</a>
                </div>
            </div>
        </div>
    </div>
</body>
</html>