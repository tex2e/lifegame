
Imports System
Imports System.Threading

Public Class Lifegame
    Private mHeight As Integer
    Private mWidth As Integer
    Private mField(,) As Integer

    Sub New(height As Integer, width As Integer)
        Me.mHeight = height
        Me.mWidth  = width
        ReDim Me.mField(Me.mHeight - 1, Me.mWidth - 1)
        InitField(Me.mHeight, Me.mWidth)
    End Sub

    Sub InitField(height As Integer, width As Integer)
        Dim randomGen As New Random
        For y As Integer = 0 To height - 1
            For x As Integer = 0 To width - 1
                Me.mField(y, x) = randomGen.Next(0, 2) '[0,1]
            Next
        Next
    End Sub

    Public Sub MyLoop()
        While True
            ClearScreen()
            Me.mField = Evolve(Me.mField)
            DumpField()
            Thread.Sleep(100) '100ms
        End While
    End Sub

    Private Function Evolve(field(,) As Integer) As Integer(,)
        Dim newField(Me.mHeight - 1, Me.mWidth - 1) As Integer
        For y As Integer = 0 To Me.mHeight - 1
            For x As Integer = 0 To Me.mWidth - 1
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
        Return newField
    End Function

    Private Function CountAliveNeighbours(field(,) As Integer,
                                          y As Integer, x As Integer) As Integer
        Dim count As Integer = 0
        For y_i As Integer = -1 To 1
            For x_i As Integer = -1 To 1
                If y_i = 0 And x_i = 0 Then Continue For

                Dim yi As Integer = Modp(y + y_i, Me.mHeight)
                Dim xi As Integer = Modp(x + x_i, Me.mWidth)
                count += field(yi, xi)
            Next
        Next
        Return count
    End Function

    Private Function Modp(a As Integer, b As Integer) As Integer
        Modp = (a + b) Mod b
    End Function

    Private Sub DumpField()
        For y As Integer = 0 To Me.mHeight - 1
            For x As Integer = 0 To Me.mWidth - 1
                Console.Write(IF(Me.mField(y, x) = 0, " ", "o"))
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
