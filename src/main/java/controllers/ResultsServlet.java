package controllers;

import models.Voting;
import services.VotingService;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Map; // ДОДАЙТЕ ЦЕЙ ІМПОРТ
import java.util.stream.Collectors; // ДОДАЙТЕ ЦЕЙ ІМПОРТ

@WebServlet("/results")
public class ResultsServlet extends HttpServlet {
    private VotingService votingService = new VotingService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Налаштування кодування для коректного відображення української мови
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");

        String id = req.getParameter("id");
        Voting voting = votingService.getVoting(id);

        if (voting != null) {
            req.setAttribute("voting", voting);
            req.setAttribute("results", votingService.getResults(id));
            req.setAttribute("total", votingService.getTotalVotesForkJoin(id));

            // Список усіх голосів для хазяїна опитування
            req.setAttribute("detailedVotes", votingService.getDetailedVotes(id));

            // Створюємо мапу для швидкого пошуку імені кандидата за ID
            Map<Integer, String> candidateNames = voting.getCandidates().stream()
                    .collect(Collectors.toMap(models.Candidate::getId, models.Candidate::getName));
            req.setAttribute("candidateNames", candidateNames);

            req.getRequestDispatcher("/WEB-INF/views/results.jsp").forward(req, resp);
        } else {
            resp.sendRedirect("index");
        }
    }
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String id = req.getParameter("id");
        models.User user = (models.User) req.getSession().getAttribute("user");

        if (id != null && user != null) {
            // Викликаємо зміну статусу
            votingService.toggleVotingStatus(id, user.getUsername());
        }

        // Після зміни статусу просто оновлюємо цю ж сторінку результатів
        resp.sendRedirect(req.getContextPath() + "/results?id=" + id);
    }
}