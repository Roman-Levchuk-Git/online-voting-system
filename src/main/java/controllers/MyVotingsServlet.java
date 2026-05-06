package controllers;

import models.User;
import models.Voting;
import services.VotingService;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/my-votings")
public class MyVotingsServlet extends HttpServlet {
    private final VotingService votingService = new VotingService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8"); // ВАЖЛИВО: додайте цей рядок першим!
        resp.setCharacterEncoding("UTF-8");
        User user = (User) req.getSession().getAttribute("user");
        if (user == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        List<Voting> myVotings = votingService.getVotingsByHost(user.getUsername());
        req.setAttribute("myVotings", myVotings);
        req.getRequestDispatcher("/WEB-INF/views/my-votings.jsp").forward(req, resp);
    }
}