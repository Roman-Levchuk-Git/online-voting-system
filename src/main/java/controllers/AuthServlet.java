package controllers;

import models.User;
import services.VotingService;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/auth")
public class AuthServlet extends HttpServlet {
    private final VotingService votingService = new VotingService();
    //обробляє відправку форм логіну та реєстрації
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");
        String user = req.getParameter("username");
        String pass = req.getParameter("password");

        if ("register".equals(action)) {
            if (votingService.register(user, pass)) {
                resp.sendRedirect("login.jsp?msg=Registered successfully");
            } else {
                resp.sendRedirect("register.jsp?error=User exists");
            }
        } else if ("login".equals(action)) {
            User authenticated = votingService.login(user, pass);
            if (authenticated != null) {
                req.getSession().setAttribute("user", authenticated);
                resp.sendRedirect("index");
            } else {
                resp.sendRedirect("login.jsp?error=Invalid credentials");
            }
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getSession().invalidate(); // Вихід з акаунту
        resp.sendRedirect("index");
    }
}