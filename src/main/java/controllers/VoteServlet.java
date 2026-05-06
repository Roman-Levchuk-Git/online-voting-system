package controllers;

import models.Vote;
import models.Voting;
import services.VotingService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/vote")
public class VoteServlet extends HttpServlet {
    private final VotingService votingService = new VotingService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8"); // ВАЖЛИВО: додайте цей рядок першим!
        resp.setCharacterEncoding("UTF-8");
        String id = req.getParameter("id");
        Voting voting = votingService.getVoting(id);

        if (voting != null) {
            req.setAttribute("voting", voting);
            req.getRequestDispatcher("/WEB-INF/views/voting.jsp").forward(req, resp);
        } else {
            resp.getWriter().write("Voting not found!");
        }
    }

    // У файлі VoteServlet.java
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8"); // Виправляє кракозябри
        resp.setContentType("text/html;charset=UTF-8");

        String votingId = req.getParameter("votingId");
        String candidateIdStr = req.getParameter("candidateId");

        // Отримуємо користувача з сесії
        models.User user = (models.User) req.getSession().getAttribute("user");

        if (user != null && votingId != null && candidateIdStr != null) {
            int candidateId = Integer.parseInt(candidateIdStr);
            String username = user.getUsername();

            // Створюємо об'єкт Vote
            models.Vote newVote = new models.Vote(username, candidateId);

            // Якщо castVote все ще червоне:
            // 1. Натисніть Alt+Enter на ньому
            // 2. Перевірте, чи змінна votingService оголошена як:
            //    private VotingService votingService = new VotingService();
            boolean wasCast = votingService.castVote(votingId, newVote);

            if (wasCast) {
                resp.sendRedirect(req.getContextPath() + "/results?id=" + votingId);
            } else {
                // Якщо вже голосували — показуємо помилку
                resp.sendRedirect(req.getContextPath() + "/index?error=already_voted");
            }
        }
    }
}