package models;

import java.time.LocalDateTime;
import java.io.Serializable;

//Об'єкт, що пов'язує користувача з обраним кандидатом.
public class Vote implements Serializable {
    private static final long serialVersionUID = 1L;
    private String userId; // особо що голосує
    private int candidateId; // за кого голосує


    public Vote(String userId, int candidateId) {
        this.userId = userId;
        this.candidateId = candidateId;

    }

    public String getUserId() { return userId; }
    public int getCandidateId() { return candidateId; }

}