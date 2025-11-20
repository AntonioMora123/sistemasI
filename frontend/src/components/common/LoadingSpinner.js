import React from 'react';

const LoadingSpinner = () => {
  return (
    <div style={spinnerStyles.container}>
      <div style={spinnerStyles.spinner}></div>
      <p style={spinnerStyles.text}>Cargando...</p>
    </div>
  );
};

const spinnerStyles = {
  container: {
    display: 'flex',
    flexDirection: 'column',
    alignItems: 'center',
    justifyContent: 'center',
    minHeight: '100vh',
    backgroundColor: '#f7fafc'
  },
  spinner: {
    width: '40px',
    height: '40px',
    border: '4px solid #e2e8f0',
    borderTop: '4px solid #667eea',
    borderRadius: '50%',
    animation: 'spin 1s linear infinite',
    marginBottom: '20px'
  },
  text: {
    color: '#718096',
    fontSize: '1.1rem'
  }
};

// Agregar keyframes CSS
const style = document.createElement('style');
style.textContent = `
  @keyframes spin {
    0% { transform: rotate(0deg); }
    100% { transform: rotate(360deg); }
  }
`;
document.head.appendChild(style);

export default LoadingSpinner;