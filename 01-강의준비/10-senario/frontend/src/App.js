import React, { useState, useEffect } from 'react';
import logo from './logo.svg';
import './App.css';

function App() {
  const [message, setMessage] = useState('');

  useEffect(() => {
    fetch('http://backend-service:3000/api/greet') // 백엔드 서비스의 URL을 사용
      .then(response => response.json())
      .then(data => setMessage(data.message))
      .catch(error => console.error('There was an error!', error));
  }, []);

  return (
    <div className="App">
      <header className="App-header">
        <img src={logo} className="App-logo" alt="logo" />
        <p>
          Edit <code>src/App.js</code> and save to reload.
        </p>
        {/* 백엔드로부터 받은 메시지를 표시 */}
        <p>Message from backend: {message}</p>
        <a
          className="App-link"
          href="https://reactjs.org"
          target="_blank"
          rel="noopener noreferrer"
        >
          Learn React
        </a>
      </header>
    </div>
  );
}

export default App;
