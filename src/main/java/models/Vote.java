package models;

import java.time.LocalDateTime;
import java.io.Serializable;

public class Vote implements Serializable {
    private static final long serialVersionUID = 1L;
    private String userId;
    private int candidateId;
    private LocalDateTime timestamp;

    public Vote(String userId, int candidateId) {
        this.userId = userId;
        this.candidateId = candidateId;
        this.timestamp = LocalDateTime.now(); // Date-time API за вимогою
    }

    public String getUserId() { return userId; }
    public int getCandidateId() { return candidateId; }
    public LocalDateTime getTimestamp() { return timestamp; }
}