from abc import ABC, abstractmethod

class Action(ABC):
 
    @abstractmethod
    def action1(self):
        pass

    @abstractmethod
    def action2(self):
        pass
