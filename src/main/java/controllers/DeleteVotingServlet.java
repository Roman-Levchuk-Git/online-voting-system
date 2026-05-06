package controllers;

import services.VotingService;
import models.User;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/delete-voting")
public class DeleteVotingServlet extends HttpServlet {
    private VotingService votingService = new VotingService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String id = req.getParameter("id");
        User user = (User) req.getSession().getAttribute("user");

        if (id != null && user != null) {
            votingService.deleteVoting(id, user.getUsername());
        }

        // Після видалення повертаємо на сторінку списку власних голосувань
        resp.sendRedirect(req.getContextPath() + "/my-votings");
    }
}