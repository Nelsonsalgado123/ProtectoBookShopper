// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "./jquery.min.js"
import "./bootstrap.bundle.min.js"
import "./sb-admi-2.min.js"

// application.js
document.addEventListener('DOMContentLoaded', () => {
    const addToCartBtns = document.querySelectorAll('.add-to-cart-btn');

    addToCartBtns.forEach((btn) => {
      btn.addEventListener('click', (event) => {
        event.preventDefault();
        const productId = btn.dataset.productId;
        addToCart(productId);
      });
    });

    function addToCart(productId) {
      const csrfToken = document.querySelector('[name="csrf-token"]').content;
      const url = `/cart_items/add_to_cart/${productId}`;

      fetch(url, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': csrfToken,
        },
        body: JSON.stringify({}),
      })
        .then((response) => response.json())
        .then((data) => {
          console.log(data); // Opcional: muestra la respuesta JSON del servidor
          // Aquí puedes agregar lógica adicional si lo deseas, como mostrar una notificación
        })
        .catch((error) => {
          console.error('Error:', error);
          // Aquí puedes manejar el error, si es necesario
        });
    }
  });
