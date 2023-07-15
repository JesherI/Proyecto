document.addEventListener('DOMContentLoaded', function() {
    var menuIcon = document.getElementById('menu-icon');
    var navbar = document.querySelector('.navbar ul');
    
    menuIcon.addEventListener('click', function() {
      navbar.classList.toggle('show');
    });
  });