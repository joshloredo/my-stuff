const loginService = require('./loginService');

// Mock the login service
jest.mock('./loginService');

describe('Login Functionality', () => {
let mockLogin;

beforeEach(() => {
    // Clear all mocks before each test
    jest.clearAllMocks();
    mockLogin = jest.spyOn(loginService, 'login');
});

afterEach(() => {
    jest.resetAllMocks();
});

test('should successfully login with valid credentials', async () => {
    const credentials = {
    username: 'validUser',
    password: 'correctPassword123'
    };
    
    mockLogin.mockResolvedValueOnce({ 
    success: true, 
    user: { id: 1, username: 'validUser' } 
    });

    const response = await loginService.login(credentials);

    expect(response.success).toBe(true);
    expect(response.user).toBeDefined();
    expect(mockLogin).toHaveBeenCalledWith(credentials);
    expect(mockLogin).toHaveBeenCalledTimes(1);
});

test('should fail login with invalid password', async () => {
    const credentials = {
    username: 'validUser',
    password: 'wrongPassword'
    };

    mockLogin.mockResolvedValueOnce({
    success: false,
    error: 'Invalid password'
    });

    const response = await loginService.login(credentials);

    expect(response.success).toBe(false);
    expect(response.error).toBe('Invalid password');
    expect(mockLogin).toHaveBeenCalledWith(credentials);
});

test('should fail login with non-existent user', async () => {
    const credentials = {
    username: 'nonExistentUser',
    password: 'anyPassword123'
    };

    mockLogin.mockResolvedValueOnce({
    success: false,
    error: 'User not found'
    });

    const response = await loginService.login(credentials);

    expect(response.success).toBe(false);
    expect(response.error).toBe('User not found');
    expect(mockLogin).toHaveBeenCalledWith(credentials);
});

describe('Input Validation', () => {
    test('should fail when username is empty', async () => {
    const credentials = {
        username: '',
        password: 'somePassword123'
    };

    mockLogin.mockResolvedValueOnce({
        success: false,
        error: 'Username is required'
    });

    const response = await loginService.login(credentials);

    expect(response.success).toBe(false);
    expect(response.error).toBe('Username is required');
    });

    test('should fail when password is empty', async () => {
    const credentials = {
        username: 'validUser',
        password: ''
    };

    mockLogin.mockResolvedValueOnce({
        success: false,
        error: 'Password is required'
    });

    const response = await loginService.login(credentials);

    expect(response.success).toBe(false);
    expect(response.error).toBe('Password is required');
    });
});
});

