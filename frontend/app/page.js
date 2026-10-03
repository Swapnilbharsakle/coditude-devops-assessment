export default function Home() {
  const apiUrl = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:8000';
  return (
    <main style={{fontFamily: 'Arial', maxWidth: 800, margin: '60px auto', padding: 20}}>
      <h1>Coditude DevOps Assessment</h1>
      <p>Next.js frontend is running.</p>
      <p>Backend endpoint: <code>{apiUrl}/health</code></p>
    </main>
  );
}
