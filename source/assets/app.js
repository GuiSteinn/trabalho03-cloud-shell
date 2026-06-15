const form = document.querySelector("#reservation-form");
const message = document.querySelector("#form-message");

if (form && message) {
  form.addEventListener("submit", (event) => {
    event.preventDefault();
    const data = new FormData(form);
    const entrada = new Date(data.get("entrada"));
    const saida = new Date(data.get("saida"));

    if (saida <= entrada) {
      message.textContent = "A data de saida deve ser posterior a data de entrada.";
      message.className = "form-message error";
      return;
    }

    message.textContent = `Simulacao registrada para ${data.get("hospede")}. O site estatico nao grava dados no servidor.`;
    message.className = "form-message success";
    form.reset();
  });
}

