package services;

import models.*;
import java.io.*;
import java.util.*;
import java.util.concurrent.*;
import java.util.stream.Collectors;

public class VotingService {
    private static Map<String, User> users = new ConcurrentHashMap<>();
    private static final Map<String, Voting> votings = new ConcurrentHashMap<>();
    private static final Map<String, List<Vote>> votes = new ConcurrentHashMap<>();
    private static final String USERS_FILE = "users.dat";
    private static final String VOTINGS_FILE = System.getProperty("user.home") + File.separator + "votings.dat";
    private static final String VOTES_FILE = System.getProperty("user.home") + File.separator + "votes.dat";

    static {
        loadUsers();
        loadAllData();
    }

    public boolean register(String username, String password) {
        if (users.containsKey(username)) return false;
        users.put(username, new User(username, password));
        saveUsers();
        return true;
    }

    public User login(String username, String password) {
        User user = users.get(username);
        return (user != null && user.getPassword().equals(password)) ? user : null;
    }

    public void createVoting(Voting voting) {
        votings.put(voting.getId(), voting);
        votes.put(voting.getId(), new CopyOnWriteArrayList<>());
        saveAllData();
    }

    public Voting getVoting(String id) { return votings.get(id); }

    // --- НОВІ МЕТОДИ ДЛЯ ГОЛОВНОЇ СТОРІНКИ ---

    public List<Voting> getAllVotings() {
        return new ArrayList<>(votings.values());
    }

    public List<Voting> searchVotings(String query) {
        if (query == null || query.trim().isEmpty()) {
            return getAllVotings();
        }
        String lowerQuery = query.toLowerCase();
        return votings.values().stream()
                .filter(v -> v.getTitle().toLowerCase().contains(lowerQuery))
                .collect(Collectors.toList());
    }

    public List<Voting> getVotingsByHost(String hostId) {
        if (hostId == null) return Collections.emptyList();
        return votings.values().stream()
                .filter(v -> hostId.equals(v.getHostId()))
                .collect(Collectors.toList());
    }

    // --- ЛОГІКА ГОЛОСУВАННЯ ТА РЕЗУЛЬТАТІВ ---

    public boolean castVote(String votingId, Vote vote) {
        Voting v = votings.get(votingId);
        if (v != null && v.isActive()) {
            List<Vote> votingVotes = votes.get(votingId);
            boolean alreadyVoted = votingVotes.stream().anyMatch(voted -> voted.getUserId().equalsIgnoreCase(vote.getUserId().trim()));
            if (!alreadyVoted) {
                votingVotes.add(vote);
                saveAllData();
                return true;
            }
        }
        return false;
    }

    public void toggleVotingStatus(String votingId, String userId) {
        Voting v = votings.get(votingId);
        if (v != null && v.getHostId().equals(userId)) v.setActive(!v.isActive());
        saveAllData();
    }

    public Map<Candidate, Long> getResults(String votingId) {
        Voting v = votings.get(votingId);
        List<Vote> vVotes = votes.getOrDefault(votingId, Collections.emptyList());
        return v.getCandidates().stream().collect(Collectors.toMap(c -> c,
                c -> vVotes.stream().filter(vote -> vote.getCandidateId() == c.getId()).count()));
    }

    public long getTotalVotesForkJoin(String votingId) {
        List<Vote> allVotes = votes.getOrDefault(votingId, Collections.emptyList());
        if (allVotes.isEmpty()) return 0;
        return ForkJoinPool.commonPool().invoke(new RecursiveTask<Long>() {
            @Override protected Long compute() { return (long) allVotes.parallelStream().count(); }
        });
    }

    private static void saveUsers() {
        try (ObjectOutputStream oos = new ObjectOutputStream(new FileOutputStream(USERS_FILE))) {
            oos.writeObject(users);
        } catch (IOException e) { e.printStackTrace(); }
    }
    // Додай цей метод у VotingService.java
    public List<Vote> getDetailedVotes(String votingId) {
        // Повертаємо копію списку голосів для конкретного голосування
        return new ArrayList<>(votes.getOrDefault(votingId, Collections.emptyList()));
    }
    public static void loadUsers() {
        File file = new File(USERS_FILE);
        if (file.exists()) {
            try (ObjectInputStream ois = new ObjectInputStream(new FileInputStream(file))) {
                users = (ConcurrentHashMap<String, User>) ois.readObject();
            } catch (Exception e) { e.printStackTrace(); }
        }
    }

    // 1. Метод для збереження (викликається через об'єкт сервісу)
    private void saveAllData() {
        try (ObjectOutputStream oosV = new ObjectOutputStream(new FileOutputStream("votings.dat"));
             ObjectOutputStream oosVotes = new ObjectOutputStream(new FileOutputStream("votes.dat"))) {
            oosV.writeObject(new HashMap<>(votings));
            oosVotes.writeObject(new HashMap<>(votes));
        } catch (IOException e) {
            System.err.println("Помилка при збереженні даних: " + e.getMessage());
        }
    }
    public void deleteVoting(String votingId, String username) {
        Voting v = votings.get(votingId);
        // Перевіряємо, чи існує голосування і чи видаляє його саме автор
        if (v != null && v.getHostId().equals(username)) {
            votings.remove(votingId);
            votes.remove(votingId); // видаляємо також всі голоси цього опитування
            saveAllData(); // зберігаємо зміни у файли .dat
        }
    }

    // 2. Статичний метод для завантаження (викликається при старті сервера)
    public static void loadAllData() {
        File fV = new File("votings.dat");
        File fVotes = new File("votes.dat");
        if (fV.exists() && fVotes.exists()) {
            try (ObjectInputStream oisV = new ObjectInputStream(new FileInputStream(fV));
                 ObjectInputStream oisVotes = new ObjectInputStream(new FileInputStream(fVotes))) {

                Map<String, Voting> v = (Map<String, Voting>) oisV.readObject();
                Map<String, List<Vote>> vt = (Map<String, List<Vote>>) oisVotes.readObject();

                votings.clear();
                votings.putAll(v);
                votes.clear();
                votes.putAll(vt);
            } catch (Exception e) {
                System.err.println("Помилка при завантаженні даних: " + e.getMessage());
            }
        }
    }
}