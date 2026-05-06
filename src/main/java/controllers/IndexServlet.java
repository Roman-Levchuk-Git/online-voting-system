package controllers;

import models.Voting;
import services.VotingService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Collection;
import java.util.stream.Collectors;

// Важливо: ми мапимо сервлет на /index
@WebServlet(urlPatterns = {"/index", "/main", ""})
public class IndexServlet extends HttpServlet {
    private final VotingService votingService = new VotingService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        VotingService.loadAllData(); // Завантажуємо свіжі дані

        String query = req.getParameter("query");
        Collection<Voting> allVotings = votingService.getAllVotings();
        Collection<Voting> filteredVotings;

        // ПЕРЕВІРКА: якщо запиту немає АБО він порожній - показуємо ВСЕ
        if (query == null || query.trim().isEmpty()) {
            filteredVotings = allVotings;
        } else {
            // Якщо користувач щось ввів - фільтруємо
            filteredVotings = allVotings.stream()
                    .filter(v -> v.getTitle() != null &&
                            v.getTitle().toLowerCase().contains(query.toLowerCase()))
                    .collect(Collectors.toList());
        }

        req.setAttribute("votings", filteredVotings);
        req.getRequestDispatcher("/index.jsp").forward(req, resp);
    }
}