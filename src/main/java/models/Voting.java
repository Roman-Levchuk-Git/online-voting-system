package models;
import java.util.List;
import java.io.Serializable;

//Об'єднує всі дані про конкретне опитування.

public class Voting implements Serializable {
    private static final long serialVersionUID = 1L;
    private String id;
    private String hostId; // Хто створив (username)
    private String title;
    private List<Candidate> candidates;
    private boolean active; // стан голосування

    public Voting(String id, String hostId, String title, List<Candidate> candidates) {
        this.id = id;
        this.hostId = hostId;
        this.title = title;
        this.candidates = candidates;
        this.active = true;
    }

    public String getId() { return id; }
    public String getHostId() { return hostId; }
    public String getTitle() { return title; }
    public List<Candidate> getCandidates() { return candidates; }
    public boolean isActive() { return active; }
    public void setActive(boolean active) { this.active = active; }
}