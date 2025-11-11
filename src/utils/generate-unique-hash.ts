export const generateUniqueHash = (): string => {
  // Generate 5 bytes (40 bits), since base32 encodes in 5 bits per character
  // 8 chars * 5 = 40 bits
  const bytes = new Uint8Array(5);
  crypto.getRandomValues(bytes);

  const base32Chars = 'abcdefghijklmnopqrstuvwxyz234567';
  let bits = 0;
  let value = 0;
  let hash = '';

  for (let i = 0; i < bytes.length; i++) {
    value = (value << 8) | bytes[i]!;
    bits += 8;
    while (bits >= 5) {
      hash += base32Chars[(value >>> (bits - 5)) & 31];
      bits -= 5;
    }
  }
  // Sometimes one or two extra bits may remain: ignore.

  // Ensure hash is exactly 8 characters.
  return hash.slice(0, 8);
};