import os

# Asegúrate de que siempre esté definida la API key, local o en la nube:
os.environ["GROQ_API_KEY"] = "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"

from agno.agent import Agent
from agno.models.groq import Groq
from agno.playground import Playground, serve_playground_app
from agno.storage.sqlite import SqliteStorage
from agno.tools.duckduckgo import DuckDuckGoTools
from agno.tools.yfinance import YFinanceTools

agent_storage = "tmp/agents.db"

web_agent = Agent(
    name="Carlos Chile",
    model=Groq(id="llama3-70b-8192"),
    tools=[DuckDuckGoTools()],
    instructions=["Always include sources"],
    storage=SqliteStorage(table_name="web_agent", db_file=agent_storage),
    add_datetime_to_instructions=True,
    add_history_to_messages=True,
    num_history_responses=5,
    markdown=True,
)

finance_agent = Agent(
    name="Finance Agent",
    model=Groq(id="llama3-8b-8192"),
    tools=[YFinanceTools(stock_price=True, analyst_recommendations=True, company_info=True, company_news=True)],
    instructions=["Always use tables to display data"],
    storage=SqliteStorage(table_name="finance_agent", db_file=agent_storage),
    add_datetime_to_instructions=True,
    add_history_to_messages=True,
    num_history_responses=5,
    markdown=True,
)

app = Playground(agents=[web_agent, finance_agent]).get_app()

if __name__ == "__main__":
    import logging
    logging.basicConfig(level=logging.INFO)
    logging.info("Backend started!")
    serve_playground_app("playground:app", reload=True)
