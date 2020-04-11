
Imports System
Imports System.Threading

Public Class Lifegame
    Public Property Height As Integer
    Public Property Width  As Integer
    Public field(,) As Integer

    Sub New(height As Integer, width As Integer)
        Me.Height = height
        Me.Width  = width
        ReDim field(Me.Height - 1, Me.Width - 1)
        InitField(Me.Height, Me.Width)
    End Sub

    Sub InitField(height As Integer, width As Integer)
        Dim randomGen As New Random
        For y As Integer = 0 To height - 1
            For x As Integer = 0 To width - 1
                Me.field(y, x) = randomGen.Next(0, 2) '[0,1]
            Next
        Next
    End Sub

    Public Sub MyLoop()
        While True
            ClearScreen()
            Me.field = Evolve(Me.field)
            DumpField()
            Thread.Sleep(100) '100ms
        End While
    End Sub

    Private Function Evolve(field(,) As Integer) As Integer(,)
        Dim newField(Me.Height - 1, Me.Width - 1) As Integer
        For y As Integer = 0 To Me.Height - 1
            For x As Integer = 0 To Me.Width - 1
                Select Case CountAliveNeighbours(field, y, x)
                    Case 2
                        newField(y, x) = field(y, x)
                    Case 3
                        newField(y, x) = 1
                    Case Else
                        newField(y, x) = 0
                End Select
            Next
        Next
        Evolve = newField
    End Function

    Private Function CountAliveNeighbours(field(,) As Integer,
                                          y As Integer, x As Integer) As Integer
        Dim count As Integer = 0
        For y_i As Integer = -1 To 1
            For x_i As Integer = -1 To 1
                If y_i = 0 And x_i = 0 Then
                    Continue For
                End If

                Dim yi As Integer = Modp(y + y_i, Me.Height)
                Dim xi As Integer = Modp(x + x_i, Me.Width)
                count += field(yi, xi)
            Next
        Next
        CountAliveNeighbours = count
    End Function

    Private Function Modp(a As Integer, b As Integer) As Integer
        Modp = (a + b) Mod b
    End Function

    Private Sub DumpField()
        For y As Integer = 0 To Me.Height - 1
            For x As Integer = 0 To Me.Width - 1
                Console.Write(IF(field(y, x) = 0, " ", "o"))
            Next
            Console.WriteLine("|")
        Next
    End Sub

    Private Sub ClearScreen()
        Console.Clear()
    End Sub

End Class


Public Class Application
    Public Shared Sub Main()
        Dim lifegame As New Lifegame(20, 40)
        lifegame.MyLoop()
    End Sub
End Class
