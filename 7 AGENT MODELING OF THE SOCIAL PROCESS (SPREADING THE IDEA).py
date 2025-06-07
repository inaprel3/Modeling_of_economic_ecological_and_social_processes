# python main.py

from mesa import Agent, Model
from mesa.time import SimultaneousActivation
import networkx as nx
import matplotlib.pyplot as plt
import random
import numpy as np

# ===== АГЕНТ =====
class SocialAgent(Agent):
    def __init__(self, unique_id, model, mutable=True):
        super().__init__(unique_id, model)
        self.state = 0
        self.next_state = 0
        self.mutable = mutable  # агент може чи не може змінити думку

    def step(self):
        if not self.mutable:
            self.next_state = self.state
            return
        neighbors = self.model.graph[self.unique_id]
        influenced = sum(self.model.schedule.agents[n].state for n in neighbors)
        if len(neighbors) > 0 and influenced / len(neighbors) > self.model.threshold:
            self.next_state = 1
        else:
            self.next_state = self.state

    def advance(self):
        self.state = self.next_state

# ===== МОДЕЛЬ =====
class SocialSpreadModel(Model):
    def __init__(self, N=100, threshold=0.3, init_frac=0.05, graph_type="erdos"):
        super().__init__()
        self.num_agents = N
        self.threshold = threshold
        self.schedule = SimultaneousActivation(self)

        # Побудова графу
        if graph_type == "erdos":
            self.graph = nx.erdos_renyi_graph(n=N, p=0.1)
        elif graph_type == "barabasi":
            self.graph = nx.barabasi_albert_graph(n=N, m=3)
        else:
            raise ValueError("Unknown graph_type")

        # Ініціалізація агентів
        for i in range(N):
            mutable = random.random() > 0.1  # 10% незмінні
            agent = SocialAgent(i, self, mutable=mutable)
            if random.random() < init_frac:
                agent.state = 1
            self.schedule.add(agent)

    def step(self):
        self.schedule.step()

    def get_states(self):
        return [agent.state for agent in self.schedule.agents]

# ===== СИМУЛЯЦІЯ =====
def run_simulation(threshold=0.3, init_frac=0.05, graph_type="erdos", steps=30, seed=42):
    random.seed(seed)
    np.random.seed(seed)
    model = SocialSpreadModel(threshold=threshold, init_frac=init_frac, graph_type=graph_type)
    fractions = []
    for _ in range(steps):
        model.step()
        states = model.get_states()
        fractions.append(sum(states) / len(states))
    return fractions

# ===== ГРАФІКИ =====
# Залежність від порогу
def plot_thresholds():
    thresholds = [0.01, 0.03, 0.05, 0.07] #0.1, 0.3, 0.5, 0.7
    for i, t in enumerate(thresholds):
        fractions = run_simulation(threshold=t, seed=100 + i)
        plt.plot(fractions, label=f"threshold={t}")
    plt.title("Залежність поширення від порогового значення")
    plt.xlabel("Крок моделювання")
    plt.ylabel("Частка, що підтримують ідею")
    plt.xlim(0, 2.5)
    plt.ylim(0.3, 1)
    plt.legend()
    plt.grid(True)
    plt.show()

# Залежність від початкової частки носіїв
def plot_init_fracs():
    init_fracs = [0.2, 0.3, 0.4] #0.01, 0.1, 0.2
    for i, frac in enumerate(init_fracs):
        fractions = run_simulation(init_frac=frac, seed=200 + i)
        plt.plot(fractions, label=f"init_frac={frac}")
    plt.title("Залежність від початкової кількості носіїв ідеї")
    plt.xlabel("Крок моделювання")
    plt.ylabel("Частка, що підтримують ідею")
    plt.xlim(0, 3.5)
    plt.ylim(0.2, 1)
    plt.legend()
    plt.grid(True)
    plt.show()

# Порівняння типів графів
def plot_graph_comparison():
    for i, graph_type in enumerate(["erdos", "barabasi"]):
        fractions = run_simulation(graph_type=graph_type, init_frac=0.2, threshold=0.2, seed=300 + i)
        plt.plot(fractions, label=graph_type)
    plt.title("Порівняння типів графів")
    plt.xlabel("Крок моделювання")
    plt.ylabel("Частка, що підтримують ідею")
    plt.xlim(0, 3)
    plt.ylim(0.55, 0.95)
    plt.legend()
    plt.grid(True)
    plt.show()

# Середня кількість кроків до насичення
def compute_avg_saturation_steps(runs=20, saturation_level=0.9, seed=400):
    def run_until_saturation(model, max_steps=100):
        for step in range(max_steps):
            model.step()
            states = model.get_states()
            if sum(states) / len(states) >= saturation_level:
                return step + 1
        return max_steps

    steps_list = []
    for i in range(runs):
        random.seed(seed + i)
        np.random.seed(seed + i)
        model = SocialSpreadModel(threshold=0.3, init_frac=0.05)
        steps_needed = run_until_saturation(model)
        steps_list.append(steps_needed)

    avg_steps = sum(steps_list) / len(steps_list)
    print(f"Середня кількість кроків до насичення (>90%): {avg_steps}")

# ===== ГОЛОВНИЙ ЗАПУСК =====
if __name__ == "__main__":
    plot_thresholds()
    plot_init_fracs()
    plot_graph_comparison()
    compute_avg_saturation_steps()
