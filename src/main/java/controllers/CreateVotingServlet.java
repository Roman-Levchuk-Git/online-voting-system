package controllers;

import models.Candidate;
import models.User;
import models.Voting;
import services.VotingService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@WebServlet("/create")
public class CreateVotingServlet extends HttpServlet {
    private final VotingService votingService = new VotingService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        // 1. Отримуємо поточного користувача із сесії
        User user = (User) req.getSession().getAttribute("user");
        if (user == null) {
            resp.sendRedirect("index"); // Якщо не залогінений - відправляємо на вхід
            return;
        }

        // 2. Отримуємо дані з форми
        String title = req.getParameter("title");
        String candidatesList = req.getParameter("candidatesList");

        // 3. Обробка кандидатів
        String[] names = candidatesList.split(",");
        List<Candidate> candidates = new ArrayList<>();
        for (int i = 0; i < names.length; i++) {
            candidates.add(new Candidate(i, names[i].trim()));
        }

        // 4. Створюємо голосування (hostId = user.getUsername())
        String votingId = UUID.randomUUID().toString();
        Voting voting = new Voting(votingId, user.getUsername(), title, candidates);

        // 5. Зберігаємо
        votingService.createVoting(voting);

        // 6. Переходимо на сторінку результатів (де кнопка керування)
        resp.sendRedirect("results?id=" + votingId);
    }
}